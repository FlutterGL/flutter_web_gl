import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

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
  final int metalAsGLTextureId;
  final int fboId;
  final int width;
  final int height;
  FlutterGLTexture(this.textureId, this.rboId, this.metalAsGLTextureId, this.fboId, this.width, this.height);

  static FlutterGLTexture fromMap(dynamic map, int fboId, int width, int height) {
    return FlutterGLTexture(map['textureId']! as int, map['rbo']! as int, map['metalAsGLTexture'] as int, fboId, width, height);
  }

  Map<String, int> toMap() {
    return {'textureId': textureId, 'rbo': rboId, 'metalAsGLTexture': metalAsGLTextureId };
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
    if (_libOpenGLES == null) {
      if (Platform.isMacOS || Platform.isIOS) {
        _libOpenGLES = LibOpenGLES(DynamicLibrary.process());
      } else {
        _libOpenGLES = LibOpenGLES(DynamicLibrary.open(resolveDylibPath('libGLESv2')));
      }
    }
    return _libOpenGLES!;
  }

  static RenderingContext getWebGLContext() {
    assert(_baseAppContext != nullptr, "OpenGL isn't initialized! Please call FlutterWebGL.initOpenGL");
    return RenderingContext._create(rawOpenGl, FlutterWebGL._baseAppContext.address);
  }

  static Future<String> get platformVersion async {
    // final String version = await _channel.invokeMethod('getPlatformVersion');
    return 'bla';
  }

  static Future<void> initOpenGL([bool debug = false]) async {
    /// make sure we don't call this twice
    if (_display != nullptr) {
      return;
    }
    loadEGL();
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

    // The following code is helpful to debug EGL issues
    // final existingConfigs = eglGetConfigs(_display, maxConfigs: 50);
    // print('Number of configs ${existingConfigs.length}');
    // for (int i = 0; i < existingConfigs.length; i++) {
    //   print('\nConfig No: $i');
    //   printConfigAttributes(_display, existingConfigs[i]);
    // }
    //printConfigAttributes(_display, _config);

    _pluginContext = eglCreateContext(
      _display,
      _config,
      contextClientVersion: 3,
    );

    final result = await _channel.invokeMethod('initOpenGL', {'openGLContext': _pluginContext.address});
    if (result == null) {
      throw EglException('Plugin.initOpenGL didn\'t return anything. Something is really wrong!');
    }

    final pluginContextAdress = result['context'] as int?;
    if (pluginContextAdress == null) {
      throw EglException('Plugin.initOpenGL didn\'t return a Context. Something is really wrong!');
    }

    final returnedPluginContext = Pointer<Void>.fromAddress(pluginContextAdress);
    if (returnedPluginContext != _pluginContext) {
      // this can only be the case if this method is called from another thread than the
      // Dart main Thread, like from an isolate. In this case the plugin has already a context
      // so we don't need this one anymore.
      eglDestroyContext(_display, _pluginContext);
    }

    final dummySurfacePointer = result['dummySurface'] as int?;
    if (dummySurfacePointer == null) {
      throw EglException('Plugin.initOpenGL didn\'t return a dummy surface. Something is really wrong!');
    }
    _dummySurface = Pointer<Void>.fromAddress(dummySurfacePointer);

    _baseAppContext = eglCreateContext(_display, _config,

        /// we link both contexts so that app and plugin can share OpenGL Objects
        shareContext: returnedPluginContext,
        contextClientVersion: 3,
        isDebugContext: debug);

    // /// to make a context current you have to provide some texture even if you don't use it afterwards
    // _dummySurface = eglCreatePbufferSurface(_display, _config, attributes: {
    //   EglSurfaceAttributes.width: 16,
    //   EglSurfaceAttributes.height: 16,
    // });

    /// bind context to this thread. All following OpenGL calls from this thread will use this context
    eglMakeCurrent(_display, _dummySurface, _dummySurface, _baseAppContext);

    if (debug && Platform.isWindows) {
      rawOpenGl.glEnable(GL_DEBUG_OUTPUT);
      rawOpenGl.glEnable(GL_DEBUG_OUTPUT_SYNCHRONOUS);
      rawOpenGl.glDebugMessageCallback(Pointer.fromFunction<GLDEBUGPROC>(glDebugOutput), nullptr);
      rawOpenGl.glDebugMessageControl(GL_DONT_CARE, GL_DONT_CARE, GL_DONT_CARE, 0, nullptr, GL_TRUE);
    }
  }

  static void glDebugOutput(
      int source, int type, int id, int severity, int length, Pointer<Int8> pMessage, Pointer<Void> pUserParam) {
    final message = pMessage.cast<Utf8>().toDartString();
    // ignore non-significant error/warning codes
    // if (id == 131169 || id == 131185 || id == 131218 || id == 131204) return;

    print("---------------");
    print("Debug message $id  $message");

    switch (source) {
      case GL_DEBUG_SOURCE_API:
        print("Source: API");
        break;
      case GL_DEBUG_SOURCE_WINDOW_SYSTEM:
        print("Source: Window System");
        break;
      case GL_DEBUG_SOURCE_SHADER_COMPILER:
        print("Source: Shader Compiler");
        break;
      case GL_DEBUG_SOURCE_THIRD_PARTY:
        print("Source: Third Party");
        break;
      case GL_DEBUG_SOURCE_APPLICATION:
        print("Source: Application");
        break;
      case GL_DEBUG_SOURCE_OTHER:
        print("Source: Other");
        break;
    }
    switch (type) {
      case GL_DEBUG_TYPE_ERROR:
        print("Type: Error");
        break;
      case GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR:
        print("Type: Deprecated Behaviour");
        break;
      case GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR:
        print("Type: Undefined Behaviour");
        break;
      case GL_DEBUG_TYPE_PORTABILITY:
        print("Type: Portability");
        break;
      case GL_DEBUG_TYPE_PERFORMANCE:
        print("Type: Performance");
        break;
      case GL_DEBUG_TYPE_MARKER:
        print("Type: Marker");
        break;
      case GL_DEBUG_TYPE_PUSH_GROUP:
        print("Type: Push Group");
        break;
      case GL_DEBUG_TYPE_POP_GROUP:
        print("Type: Pop Group");
        break;
      case GL_DEBUG_TYPE_OTHER:
        print("Type: Other");
        break;
    }

    switch (severity) {
      case GL_DEBUG_SEVERITY_HIGH:
        print("Severity: high");
        break;
      case GL_DEBUG_SEVERITY_MEDIUM:
        print("Severity: medium");
        break;
      case GL_DEBUG_SEVERITY_LOW:
        print("Severity: low");
        break;
      case GL_DEBUG_SEVERITY_NOTIFICATION:
        print("Severity: notification");
        break;
    }
    print('\n');
  }

  static Future<FlutterGLTexture> createTexture(int width, int height) async {
    final result = await _channel.invokeMethod('createTexture', {"width": width, "height": height});

    Pointer<Uint32> fbo = calloc();
    rawOpenGl.glGenFramebuffers(1, fbo);
    rawOpenGl.glBindFramebuffer(GL_FRAMEBUFFER, fbo.value);

    final newTexture = FlutterGLTexture.fromMap(result, fbo.value, width, height);

    print(rawOpenGl.glGetError());

    if (newTexture.metalAsGLTextureId != 0) {
      // Draw to metal interop texture directly
      rawOpenGl.glBindTexture(GL_TEXTURE_2D, newTexture.metalAsGLTextureId);
      rawOpenGl.glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, newTexture.metalAsGLTextureId, 0);
    }
    else {
      rawOpenGl.glBindRenderbuffer(GL_RENDERBUFFER, newTexture.rboId);
      rawOpenGl.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, newTexture.rboId);
    }
    var frameBufferCheck = rawOpenGl.glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (frameBufferCheck != GL_FRAMEBUFFER_COMPLETE) {
      print("Framebuffer (color) check failed: ${frameBufferCheck.toRadixString(16)}");
    }

    Pointer<Int32> depthBuffer = calloc();
    rawOpenGl.glGenRenderbuffers(1, depthBuffer.cast());
    rawOpenGl.glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer.value);
    rawOpenGl.glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    rawOpenGl.glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);

    rawOpenGl.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer.value);
    frameBufferCheck = rawOpenGl.glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (frameBufferCheck != GL_FRAMEBUFFER_COMPLETE) {
      print("Framebuffer (depth) check failed: ${frameBufferCheck.toRadixString(16)}");
    }
    rawOpenGl.glViewport(0, 0, width, height);
    _activeFramebuffer = fbo.value;

    calloc.free(fbo);
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

      Pointer<Uint32> fbo = calloc();
      fbo.value = texture.fboId;
      rawOpenGl.glDeleteBuffers(1, fbo);
      calloc.free(fbo);
    }
    await _channel.invokeMethod('deleteTexture', {"textureId": texture.textureId});
  }

  static void activateTexture(FlutterGLTexture texture) {
    rawOpenGl.glBindFramebuffer(GL_FRAMEBUFFER, texture.fboId);
    if (texture.metalAsGLTextureId != 0) {
      // Draw to metal interop texture directly
      rawOpenGl.glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture.metalAsGLTextureId, 0);
    }
    else {
      rawOpenGl.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, texture.rboId);
    }
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
