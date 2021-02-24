import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final textures = <FlutterGLTexture>[];
  int textureId = 0;
  static const textureWidth = 1920;
  static const textureHeight = 1080;
  static const aspect = textureWidth / textureHeight;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await FlutterWebGL.initOpenGL(true);

    try {
      textures.add(await FlutterWebGL.createTexture(textureWidth, textureHeight));
    } on PlatformException {
      print("failed to get texture id");
    }

    resetLessons();
    lesson = Lesson7();

    /// Updating all Textues takes a slighllty less than 150ms
    /// so we can't get much faster than this at the moment because it could happen that
    /// the timer starts a new async function while the last one hasn't finished
    /// which creates an OpenGL Exception

    if (!mounted) return;
    setState(() {
      textureId = textures[0].textureId;
    });
    // timer = Timer.periodic(const Duration(milliseconds: 16), updateTexture);
    ticker = createTicker(updateTexture);
    ticker.start();
  }

  Timer? timer;
  Stopwatch stopwatch = Stopwatch();

  late Ticker ticker;
  static bool updating = false;
  int animationCounter = 0;
  int totalTime = 0;
  int iterationCount = 60;
  int framesOver = 0;
  void updateTexture(_) async {
    if (textureId == 0) return;
    if (!updating) {
      updating = true;
      stopwatch.reset();
      stopwatch.start();
      textures[0].activate();
      lesson?.handleKeys();
      lesson?.animate(animationCounter += 2);
      lesson?.drawScene(-1, 0, aspect);
      await textures[0].signalNewFrameAvailable();
      stopwatch.stop();
      totalTime += stopwatch.elapsedMilliseconds;
      if (stopwatch.elapsedMilliseconds > 16) {
        framesOver++;
      }
      if (--iterationCount == 0) {
        // print('Time: ${totalTime / 60} - Framesover $framesOver');
        totalTime = 0;
        iterationCount = 60;
        framesOver = 0;
      }
      updating = false;
    } else {
      print('Too slow');
    }
  }

  void dispose() {
    ticker.dispose();
    timer?.cancel();
    super.dispose();
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
          return GestureDetector(
              onVerticalDragStart: verticalDragStart,
              onVerticalDragUpdate: verticalDragUpdate,
              onHorizontalDragStart: horizontalDragStart,
              onHorizontalDragUpdate: horizontalDragUpdate,
              child: Container(child: Texture(textureId: textureId)));
        }),
      ),
    );
  }

  double lastVertical = 0;

  double lastHorizontal = 0;

  void verticalDragStart(DragStartDetails details) {}

  void verticalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dy < 0) {
      movement = Directions.up;
      print('up');
    } else if (details.delta.dy > 0) {
      print('down');
      movement = Directions.down;
    }
  }

  void horizontalDragStart(DragStartDetails details) {}
  void horizontalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dx < 0) {
      movement = Directions.right;
      print('right');
    } else if (details.delta.dx > 0) {
      movement = Directions.left;
      print('left');
    }
  }
}
