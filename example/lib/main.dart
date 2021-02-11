import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_gl/flutter_web_gl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
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

    try {
      textureId = await FlutterWebGL.createTexture(600, 400);
    } on PlatformException {
      print("failed to get texture id");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              SizedBox(width: 600, height: 400, child: Texture(textureId: textureId)),
              MaterialButton(
                onPressed: draw,
                color: Colors.grey,
                child: Text('Draw'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void draw() async {
    final gl = FlutterWebGL.rawOpenGl;

    int vertexShader = gl.glCreateShader(GL_VERTEX_SHADER);
    var sourceString = Utf8.toUtf8(vertexShaderSource);
    var arrayPointer = allocate<Pointer<Int8>>();
    arrayPointer.value = Pointer.fromAddress(sourceString.address);
    gl.glShaderSource(vertexShader, 1, arrayPointer, nullptr);
    gl.glCompileShader(vertexShader);
    free(arrayPointer);
    free(sourceString);

    int fragmentShader = gl.glCreateShader(GL_FRAGMENT_SHADER);
    sourceString = Utf8.toUtf8(fragmentShaderSource);
    arrayPointer = allocate<Pointer<Int8>>();
    arrayPointer.value = Pointer.fromAddress(sourceString.address);
    gl.glShaderSource(fragmentShader, 1, arrayPointer, nullptr);
    gl.glCompileShader(fragmentShader);
    free(arrayPointer);
    free(sourceString);

    final shaderProgram = gl.glCreateProgram();
    gl.glAttachShader(shaderProgram, vertexShader);
    gl.glAttachShader(shaderProgram, fragmentShader);
    gl.glLinkProgram(shaderProgram);

    gl.glClearColor(0, 0, 1, 1);
    gl.glClear(GL_COLOR_BUFFER_BIT);

    gl.glUseProgram(shaderProgram);

    final points = [-0.5, -0.5, 0.0, 0.5, -0.5, 0.0, 0.0, 0.5, 0.0];
    Pointer<Uint32> vbo = allocate();
    gl.glGenBuffers(1, vbo);
    gl.glBindBuffer(GL_ARRAY_BUFFER, vbo.value);
    gl.glBufferData(GL_ARRAY_BUFFER, 36, floatListToArrayPointer(points).cast(), GL_STATIC_DRAW);

    gl.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, Pointer<Void>.fromAddress(0).cast());
    gl.glEnableVertexAttribArray(0);
    gl.glDrawArrays(GL_TRIANGLES, 0, 3);

    gl.glDeleteShader(vertexShader);
    gl.glDeleteShader(fragmentShader);

    await FlutterWebGL.updateTexture(textureId);
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
    'out vec4 FragColor;\n' //
    '\n' //
    'void main()\n' //
    '{\n' //
    '    FragColor = vec4(1.0f, 0.0f, 0.0f, 1.0f);\n' //
    '} \n'; //

Pointer<Float> floatListToArrayPointer(List<double> list) {
  final ptr = allocate<Float>(count: list.length);
  for (var i = 0; i < list.length; i++) {
    ptr.elementAt(i).value = list[i];
  }
  return ptr;
}

    // if (success.value == 0) {
    //   Pointer<Int8> infoLog = allocate(count: 512);
    //   gl.glGetProgramInfoLog(shaderProgram, 512, nullptr, infoLog);
    //   print('ERROR::SHADER::FRAGMENT:LINKER_FAILED\n' + Utf8.fromUtf8(infoLog.cast()));
    //   free(infoLog);
    // }