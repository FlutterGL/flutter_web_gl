import 'dart:async';
import 'dart:ffi';

import 'package:dylib/dylib.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_gl/lib_egl.dart';
import 'package:opengl_es_bindings/opengl_es_bindings.dart';

export 'package:opengl_es_bindings/opengl_es_bindings.dart';

part 'web_gl.dart';

class FlutterGLTexture {
  final int textureId;
  final int rboId;
  final int fboId;
  final int width;
  final int height;
  FlutterGLTexture(this.textureId, this.rboId, this.fboId, this.width, this.height);

  static FlutterGLTexture fromMap(dynamic map, int fboId, int width, int height) {
    return FlutterGLTexture(map['textureId']! as int, map['rbo']! as int, fboId, width, height);
  }

  Map<String, int> toMap() {
    return {'textureId': textureId, 'rbo': rboId};
  }

  /// Whenever you finished your rendering you have to call this function to signal
  /// the Flutterengine that it can display the rendering
  /// Despite this being an asyc function it probably doesn't make sense to await it
  Future<void> signalNewFrameAvailable() async {
    await FlutterWebGL.updateTexture(this);
  }

  /// As you can have multiple Texture objects, but WebGL allways draws in the currently
  /// active one you have to call this function if you use more than one Textureobject before
  /// you can start rendering on it. If you forget it you will render into the wrong Texture.
  void activate() {
    FlutterWebGL.activateTexture(this);
    FlutterWebGL.rawOpenGl.glViewport(0, 0, width, height);
  }
}

class FlutterWebGL {
  static const MethodChannel _channel = const MethodChannel('flutter_web_gl');

  static LibOpenGLES? _libOpenGLES;
  static Pointer<Void> _display = nullptr;
  static late Pointer<Void> _config;
  static Pointer<Void> _baseAppContext = nullptr;
  static Pointer<Void> _pluginContext = nullptr;
  static late Pointer<Void> _dummySurface;
  static int? _activeFramebuffer;

  static LibOpenGLES get rawOpenGl {
    final libPath = resolveDylibPath(
      'libGLESv2',
    );
    return _libOpenGLES ??= LibOpenGLES(DynamicLibrary.open(libPath));
  }

  static RenderingContext getWebGLContext() {
    assert(_baseAppContext != nullptr, "OpenGL isn't initialized! Please call FlutterWebGL.initOpenGL");
    return RenderingContext._create(rawOpenGl, FlutterWebGL._baseAppContext.address);
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> initOpenGL() async {
    /// make sure we don't call this twice
    if (_display != nullptr) {
      return;
    }
    _display = eglGetDisplay();
    final initializeResult = eglInitialize(_display);

    debugPrint('EGL version: $initializeResult');

    final chooseConfigResult = eglChooseConfig(
      _display,
      attributes: {
        EglConfigAttribute.renderableType: EglValue.openglEs3Bit.toIntValue(),
        EglConfigAttribute.redSize: 8,
        EglConfigAttribute.greenSize: 8,
        EglConfigAttribute.blueSize: 8,
        EglConfigAttribute.alphaSize: 8,
        EglConfigAttribute.depthSize: 16,
      },
      maxConfigs: 1,
    );

    _config = chooseConfigResult[0];

    _pluginContext = eglCreateContext(
      _display,
      _config,
      contextClientVersion: 3,
    );

    final pluginContextAdress =
        await _channel.invokeMethod<int>('initOpenGL', {'openGLContext': _pluginContext.address});
    if (pluginContextAdress == null) {
      throw EglException('Plugin.initOpenGL didn\'t return an OpenGL context. Something is really wrong!');
    }

    final returnedPluginContext = Pointer<Void>.fromAddress(pluginContextAdress);
    if (returnedPluginContext != _pluginContext) {
      // this can only be the case if this method is called from another thread than the
      // Dart main Thread, like from an isolate. In this case the plugin has already a context
      // so we don't need this one anymore.
      eglDestroyContext(_display, _pluginContext);
    }

    _baseAppContext = eglCreateContext(
      _display,
      _config,

      /// we link both contexts so that app and plugin can share OpenGL Objects
      shareContext: returnedPluginContext,
      contextClientVersion: 3,
    );

    /// to make a context current you have to provide some texture even if you don't use it afterwards
    _dummySurface = eglCreatePbufferSurface(_display, _config, attributes: {
      EglSurfaceAttributes.width: 16,
      EglSurfaceAttributes.height: 16,
    });

    /// bind context to this thread. All following OpenGL calls from this thread will use this context
    eglMakeCurrent(_display, _dummySurface, _dummySurface, _baseAppContext);
  }

  static Future<FlutterGLTexture> createTexture(int width, int height) async {
    final result = await _channel.invokeMethod('createTexture', {"width": width, "height": height});

    Pointer<Uint32> fbo = allocate();
    rawOpenGl.glGenFramebuffers(1, fbo);
    rawOpenGl.glBindFramebuffer(GL_FRAMEBUFFER, fbo.value);

    final newTexture = FlutterGLTexture.fromMap(result, fbo.value, width, height);

    print(rawOpenGl.glGetError());
    rawOpenGl.glBindRenderbuffer(GL_RENDERBUFFER, newTexture.rboId);

    rawOpenGl.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, newTexture.rboId);
    var frameBufferCheck = rawOpenGl.glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (frameBufferCheck != GL_FRAMEBUFFER_COMPLETE) {
      print("Framebuffer (color) check failed: $frameBufferCheck");
    }

    Pointer<Int32> depthBuffer = allocate();
    rawOpenGl.glGenRenderbuffers(1, depthBuffer.cast());
    rawOpenGl.glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer.value);
    rawOpenGl.glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);

    rawOpenGl.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer.value);
    frameBufferCheck = rawOpenGl.glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (frameBufferCheck != GL_FRAMEBUFFER_COMPLETE) {
      print("Framebuffer (depth) check failed: $frameBufferCheck");
    }
    rawOpenGl.glViewport(0, 0, width, height);
    _activeFramebuffer = fbo.value;

    free(fbo);
    return newTexture;
  }

  static Future<void> updateTexture(FlutterGLTexture texture) async {
    assert(_activeFramebuffer != null, 'There is no active FlutterGL Texture to update');
    await _channel.invokeMethod('updateTexture', {"textureId": texture.textureId});
  }

  static Future<void> deleteTexture(FlutterGLTexture texture) async {
    assert(_activeFramebuffer != null, 'There is no active FlutterGL Texture to delete');
    if (_activeFramebuffer == texture.fboId) {
      rawOpenGl.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, 0);

      Pointer<Uint32> fbo = allocate();
      fbo.value = texture.fboId;
      rawOpenGl.glDeleteBuffers(1, fbo);
      free(fbo);
    }
    await _channel.invokeMethod('deleteTexture', {"textureId": texture.textureId});
  }

  static void activateTexture(FlutterGLTexture texture) {
    rawOpenGl.glBindFramebuffer(GL_FRAMEBUFFER, texture.fboId);
    rawOpenGl.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, texture.rboId);
    printOpenGLError('activateTextue ${texture.textureId}');
    _activeFramebuffer = texture.fboId;
  }

  static void printOpenGLError(String message) {
    var glGetError = rawOpenGl.glGetError();
    if (glGetError != GL_NO_ERROR) {
      print('$message: ${glGetError}');
    }
  }
}
