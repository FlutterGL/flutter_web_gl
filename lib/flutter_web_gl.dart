import 'dart:async';
import 'dart:ffi';

import 'package:dylib/dylib.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_gl/lib_egl.dart';
import 'package:opengl_es_bindings/opengl_es_bindings.dart';

export 'package:opengl_es_bindings/opengl_es_bindings.dart';

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

    _baseAppContext = eglCreateContext(
      _display,
      _config,
      contextClientVersion: 3,
    );
    _pluginContext = eglCreateContext(
      _display,
      _config,
      shareContext: _baseAppContext,
      contextClientVersion: 3,
    );

    /// to make a context current you have to provide some texture even if you don't use it afterwards
    _dummySurface = eglCreatePbufferSurface(_display, _config, attributes: {
      EglSurfaceAttributes.width: 16,
      EglSurfaceAttributes.height: 16,
    });
    eglMakeCurrent(_display, _dummySurface, _dummySurface, _baseAppContext);

    // The plugin makes sure that it doesn't matter if this is called multiple times
    await _channel
        .invokeMethod('initOpenGL', {'openGLContext': _pluginContext.address});
    // final p = FlutterWebGl.rawOpenGl.glGetString(GL_VENDOR);
    // String str = Utf8.fromUtf8(p.cast());
  }

  static Future<int> createTexture(int width, int height) async {
    final result =
        await _channel.invokeMethod('createTexture', [width, height]);

    Pointer<Uint32> fbo = allocate();
    rawOpenGl.glGenFramebuffers(1, fbo);
    rawOpenGl.glBindFramebuffer(GL_FRAMEBUFFER, fbo.value);

    final rbo = result['rbo'] as int;
    rawOpenGl.glBindRenderbuffer(GL_RENDERBUFFER, rbo);

    rawOpenGl.glFramebufferRenderbuffer(
        GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, rbo);
    final frameBufferCheck = rawOpenGl.glCheckFramebufferStatus(GL_FRAMEBUFFER);
    print(frameBufferCheck);
    // final p = rawOpenGl.glGetString(GL_VENDOR);
    // String str = Utf8.fromUtf8(p.cast());
    return result["textureId"];
  }

  static Future<void> updateTexture(int textureId) async {
    await _channel.invokeMethod('updateTexture', {"textureId": textureId});
  }
}
