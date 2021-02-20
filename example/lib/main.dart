import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_gl/flutter_web_gl.dart';
import 'package:flutter_web_gl_example/learn_gl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final textures = <FlutterGLTexture>[];
  int textureId = 0;
  static const textureWidth = 1280;
  static const textureHeight = 1280;
  static const aspect = textureWidth / textureHeight;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await FlutterWebGL.initOpenGL();

    try {
      textures.add(await FlutterWebGL.createTexture(1280, 1024));
    } on PlatformException {
      print("failed to get texture id");
    }

    resetLessons();
    lesson = Lesson3();

    /// Updating all Textues takes a slighllty less than 150ms
    /// so we can't get much faster than this at the moment because it could happen that
    /// the timer starts a new async function while the last one hasn't finished
    /// which creates an OpenGL Exception

    if (!mounted) return;
    setState(() {
      textureId = textures[0].textureId;
    });
    Timer.periodic(const Duration(milliseconds: 100), updateTexture);
  }

  static bool updating = false;
  int animationCounter = 0;

  void updateTexture(Timer _) async {
    if (textureId == 0) return;
    if (!updating) {
      updating = true;
      textures[0].activate();
      lesson?.animate(animationCounter += 2);
      lesson?.drawScene(0, 0, aspect);
      await textures[0].signalNewFrameAvailable();
    }
    updating = false;
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
          return Container(child: Texture(textureId: textureId));
        }),
      ),
    );
  }
}
