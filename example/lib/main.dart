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
      textureId = await FlutterWebGL.createTexture(200, 100);
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
    gl.glClearColor(0, 0, 60, 255);
    gl.glClear(GL_COLOR_BUFFER_BIT);

    final points = [-0.5, -0.5, 0.0, 0.5, -0.5, 0.0, 0.0, 0.5, 0.0];

    Pointer<Uint32> vbo = allocate();
    gl.glGenBuffers(1, vbo);
    gl.glBindBuffer(GL_ARRAY_BUFFER, vbo.address);
    gl.glBufferData(GL_ARRAY_BUFFER, points.length, floatListToArrayPointer(points).cast(), GL_STATIC_DRAW);

    int vertexShader = gl.glCreateShader(GL_VERTEX_SHADER);
    gl.glShaderSource(
        vertexShader, 1, Pointer<Void>.fromAddress(Utf8.toUtf8(vertexShaderSource).cast().address).cast(), nullptr);
    gl.glCompileShader(vertexShader);
    Pointer<Uint32> success = allocate();
    gl.glGetShaderiv(vertexShader, GL_COMPILE_STATUS, success.cast());
    print(success.value);

    int fragmentShader = gl.glCreateShader(GL_FRAGMENT_SHADER);
    gl.glShaderSource(
        fragmentShader, 1, Pointer<Pointer<Int8>>.fromAddress(Utf8.toUtf8(fragmentShaderSource).address), nullptr);
    gl.glCompileShader(fragmentShader);
    gl.glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, success.cast());
    print(success.value);

    final shaderProgram = gl.glCreateProgram();
    gl.glAttachShader(shaderProgram, vertexShader);
    gl.glAttachShader(shaderProgram, fragmentShader);
    gl.glLinkProgram(shaderProgram);
    gl.glGetProgramiv(shaderProgram, GL_LINK_STATUS, success.cast());
    print(success.value);

    gl.glUseProgram(shaderProgram);

    gl.glDeleteShader(vertexShader);
    gl.glDeleteShader(fragmentShader);
    gl.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * 4, nullptr); //this was in original (void*)0
    gl.glEnableVertexAttribArray(0);
    gl.glDrawArrays(GL_TRIANGLES, 0, 3);

    await FlutterWebGL.updateTexture(textureId);
  }
}

const vertexShaderSource = //
    '#version 330 core\n' //
    'layout (location = 0) in vec3 aPos;\n' //
    '\n' //
    'void main()\n' //
    '{\n' //
    '    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n' //
    '}\n'; //

const fragmentShaderSource = //
    '#version 330 core\n' //
    'out vec4 FragColor;\n' //
    '\n' //
    'void main()\n' //
    '{\n' //
    '    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n' //
    '} \n'; //

Pointer<Float> floatListToArrayPointer(List<double> list) {
  final ptr = allocate<Float>(count: list.length);
  for (var i = 0; i < list.length; i++) {
    ptr.elementAt(i).value = list[i];
  }
  return ptr;
}
