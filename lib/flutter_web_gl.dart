import 'dart:async';
import 'dart:ffi';

import 'package:dylib/dylib.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_gl/lib_egl.dart';
import 'package:opengl_es_bindings/opengl_es_bindings.dart';

export 'package:opengl_es_bindings/opengl_es_bindings.dart';

class FlutterGLTexture {
  final int textureId;
  final int rboId;
  FlutterGLTexture(this.textureId, this.rboId);

  static FlutterGLTexture fromMap(Map<String, Object> map) {
    return FlutterGLTexture(map['textureId']! as int, map['rbo']! as int);
  }

  Map<String, int> toMap() {
    return {'textureId': textureId, 'rbo': rboId};
  }
}

class FlutterWebGL {
  static const MethodChannel _channel = const MethodChannel('flutter_web_gl');

  static LibOpenGLES? _libOpenGLES;
  static Pointer<Void> _display = nullptr;
  static late Pointer<Void> _config;
  static late Pointer<Void> _baseAppContext;
  static late Pointer<Void> _pluginContext;
  static late Pointer<Void> _dummySurface;

  static LibOpenGLES get rawOpenGl {
    final libPath = resolveDylibPath(
      'libGLESv2',
    );
    return _libOpenGLES ??= LibOpenGLES(DynamicLibrary.open(libPath));
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void initOpenGL() async {
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

  static Future<int> createTexture(int width, int height) async {
    final result = await _channel.invokeMethod('createTexture', {"width": width, "height": height});

    Pointer<Uint32> fbo = allocate();
    rawOpenGl.glGenFramebuffers(1, fbo);
    rawOpenGl.glBindFramebuffer(GL_FRAMEBUFFER, fbo.value);

    print(rawOpenGl.glGetError());
    final rbo = result['rbo'] as int;
    rawOpenGl.glBindRenderbuffer(GL_RENDERBUFFER, rbo);

    rawOpenGl.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, rbo);
    var frameBufferCheck = rawOpenGl.glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (frameBufferCheck != GL_FRAMEBUFFER_COMPLETE) {
      print("Framebuffer (color) check failed: $frameBufferCheck");
    }
    rawOpenGl.glViewport(0, 0, 600, 400);

    return result["textureId"];
  }

  //TODO has to be clarified if we have to bind the buffer here or not (to late right now to think)
  static Future<void> updateTexture(int textureId) async {
    await _channel.invokeMethod('updateTexture', {"textureId": textureId});
  }

  //TODO has to be clarified if we have to unbind anything at this point.
  static Future<void> deleteTexture(int textureId) async {
    await _channel.invokeMethod('deleteTexture', {"textureId": textureId});
  }
}
