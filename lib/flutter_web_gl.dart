import 'dart:async';
import 'dart:ffi' as ffi;

import 'package:dylib/dylib.dart';
import 'package:flutter/services.dart';
import 'package:opengl_es_bindings/opengl_es_bindings.dart';

export 'package:opengl_es_bindings/opengl_es_bindings.dart';

class FlutterWebGl {
  static const MethodChannel _channel = const MethodChannel('flutter_web_gl');

  static LibOpenGLES? _libOpenGLES;
  static LibOpenGLES get rawOpenGl {
    return _libOpenGLES ??= LibOpenGLES(ffi.DynamicLibrary.open(
      resolveDylibPath(
        'openGL32',
      ),
    ));
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> createTexture(int width, int height) async {
    final result =
        await _channel.invokeMethod('createTexture', [width, height]);
    return result["textureId"];
  }
}
