import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_gl/flutter_web_gl.dart';
// import 'package:random_color/random_color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  int shaderProgram = 0;
  final numTextures = 100;
  final textures = <FlutterGLTexture>[];
  int textureId = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterWebGL.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    FlutterWebGL.initOpenGL();

    textures.add(await FlutterWebGL.createTexture(640, 320));
    // try {
    //   for (int i = 0; i < 100; i++) {
    //   }
    // } on PlatformException {
    //   print("failed to get texture id");
    // }

    createShaderProgram();

    /// Updating all Textues takes a slighllty less than 150ms
    /// so we can't get much faster than this at the moment because it could happen that
    /// the timer starts a new async function while the last one hasn't finished
    /// which creates an OpenGL Exception
    //  Timer.periodic(const Duration(milliseconds: 150), updateTextures);

    updateTextures(null);
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      textureId = textures[0].textureId;
    });
  }

  static bool updating = false;

  void updateTextures(Timer? _) async {
    if (!updating) {
      updating = true;
      for (final t in textures) {
        t.activate();
        draw();
        await t.signalNewFrameAvailable();
      }
      updating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          final squareSize = constraints.maxWidth / 2;
          return Wrap(
            children: [
              // for (int i = 0; i < 200; i++)
              // if (textures.length > i % numTextures)
              Container(width: squareSize, height: squareSize, child: Texture(textureId: textureId)),
            ],
          );
        }),
      ),
    );
  }

  void createShaderProgram() {
    final gl = FlutterWebGL.rawOpenGl;

    int vertexShader = gl.glCreateShader(GL_VERTEX_SHADER);
    var sourceString = vertexShaderSource.toNativeUtf8();
    var arrayPointer = calloc<Pointer<Int8>>();
    arrayPointer.value = Pointer.fromAddress(sourceString.address);
    gl.glShaderSource(vertexShader, 1, arrayPointer, nullptr);
    gl.glCompileShader(vertexShader);
    calloc.free(arrayPointer);
    calloc.free(sourceString);

    int fragmentShader = gl.glCreateShader(GL_FRAGMENT_SHADER);
    sourceString = fragmentShaderSource.toNativeUtf8();
    arrayPointer = calloc<Pointer<Int8>>();
    arrayPointer.value = Pointer.fromAddress(sourceString.address);
    gl.glShaderSource(fragmentShader, 1, arrayPointer, nullptr);
    gl.glCompileShader(fragmentShader);
    final compiled = calloc<Int32>();
    gl.glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, compiled);
    if (compiled.value == 0) {
      final infoLen = calloc<Int32>();

      gl.glGetShaderiv(fragmentShader, GL_INFO_LOG_LENGTH, infoLen);

      if (infoLen.value > 1) {
        final infoLog = calloc<Int8>(infoLen.value);

        gl.glGetShaderInfoLog(fragmentShader, infoLen.value, nullptr, infoLog);
        print("Error compiling shader:\n${infoLog.cast<Utf8>().toDartString()}");

        calloc.free(infoLog);
      }

      gl.glDeleteShader(fragmentShader);
      return;
    }
    calloc.free(arrayPointer);
    calloc.free(sourceString);

    shaderProgram = gl.glCreateProgram();
    gl.glAttachShader(shaderProgram, vertexShader);
    gl.glAttachShader(shaderProgram, fragmentShader);
    gl.glLinkProgram(shaderProgram);

    gl.glDeleteShader(vertexShader);
    gl.glDeleteShader(fragmentShader);
    gl.glUseProgram(shaderProgram);
  }

  void draw() async {
    final gl = FlutterWebGL.rawOpenGl;

    int colorLocation = gl.glGetUniformLocation(shaderProgram, 'color'.toNativeUtf8().cast());
    // final randomColor = RandomColor();

    final bgColor = Colors.blue;
    // randomColor.randomColor(colorBrightness: ColorBrightness.dark);

    gl.glClearColor(bgColor.red.toDouble() / 255, bgColor.green.toDouble() / 255, bgColor.blue.toDouble() / 255, 1);
    gl.glClear(GL_COLOR_BUFFER_BIT);

    final color = Colors.green;
    // randomColor.randomColor(colorBrightness: ColorBrightness.light);
    gl.glUniform4f(colorLocation, (color.red.toDouble() / 255), color.green.toDouble() / 255,
        color.blue.toDouble() / 255, color.alpha.toDouble() / 255);

    final points = [-0.5, -0.5, 0.0, 0.5, -0.5, 0.0, 0.0, 0.5, 0.0];
    Pointer<Uint32> vbo = calloc();
    gl.glGenBuffers(1, vbo);
    gl.glBindBuffer(GL_ARRAY_BUFFER, vbo.value);
    gl.glBufferData(GL_ARRAY_BUFFER, 36, floatListToArrayPointer(points).cast(), GL_STATIC_DRAW);

    gl.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, Pointer<Void>.fromAddress(0).cast());
    gl.glEnableVertexAttribArray(0);
    gl.glDrawArrays(GL_TRIANGLES, 0, 3);
    gl.glFlush();
  }
}

const vertexShaderSource = //
    '#version 300 es\n' //
    'layout (location = 0) in vec4 aPos;\n' //
    '\n' //
    'void main()\n' //
    '{\n' //
    '    gl_Position = aPos;\n' //
    '}\n'; //

const fragmentShaderSource = //
    '#version 300 es\n' //
    'precision mediump float;\n'
    'uniform vec4 color;\n'
    'out vec4 FragColor;\n' //
    '\n' //
    'void main()\n' //
    '{\n' //
    '    FragColor = color;\n' //
    '} \n'; //

Pointer<Float> floatListToArrayPointer(List<double> list) {
  final ptr = calloc<Float>(list.length);
  for (var i = 0; i < list.length; i++) {
    ptr.elementAt(i).value = list[i];
  }
  return ptr;
}

// if (success.value == 0) {
//   Pointer<Int8> infoLog = calloc( 512);
//   gl.glGetProgramInfoLog(shaderProgram, 512, nullptr, infoLog);
//   print('ERROR::SHADER::FRAGMENT:LINKER_FAILED\n' + Utf8.fromUtf8(infoLog.cast()));
//   calloc.free(infoLog);
// }
