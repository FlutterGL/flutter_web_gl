import 'dart:async';
import 'dart:ffi' as ffi;

import 'package:dylib/dylib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_gl/lib_egl.dart';
import 'package:opengl_es_bindings/opengl_es_bindings.dart';

export 'package:opengl_es_bindings/opengl_es_bindings.dart';

class FlutterWebGl {
  static const MethodChannel _channel = const MethodChannel('flutter_web_gl');

  static LibOpenGLES? _libOpenGLES;
  static LibOpenGLES get rawOpenGl {
    final libPath = resolveDylibPath(
      'libGLESv2',
    );
    return _libOpenGLES ??= LibOpenGLES(ffi.DynamicLibrary.open(libPath));
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void initOpenGL() {
    final display = eglGetDisplay();
    final initializeResult = eglInitialize(display);

    debugPrint('EGL version: $initializeResult');

    final chooseConfigResult = eglChooseConfig(
      display,
      attributes: {
        EglConfigAttribute.renderableType: EglValue.openglEs2Bit.toIntValue(),
        EglConfigAttribute.redSize: 8,
        EglConfigAttribute.greenSize: 8,
        EglConfigAttribute.blueSize: 8,
        EglConfigAttribute.alphaSize: 8,
        EglConfigAttribute.depthSize: 16,
      },
      maxConfigs: 1,
    );

    final config = chooseConfigResult[0];

    final context = eglCreateContext(
      display,
      config,
      contextClientVersion: 2,
    );

    final surface = eglCreatePbufferSurface(display, config, attributes: {
      EglSurfaceAttributes.width: 16,
      EglSurfaceAttributes.height: 16,
    });
    eglMakeCurrent(display, surface, surface, context);
  }

  static Future<int> createTexture(int width, int height) async {
    final result =
        await _channel.invokeMethod('createTexture', [width, height]);
    return result["textureId"];
  }
}
