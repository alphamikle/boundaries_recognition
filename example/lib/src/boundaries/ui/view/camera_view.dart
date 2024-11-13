import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:image/image.dart' show Image, copyRotate;

import '../../../utils/bench.dart';
import '../../../utils/camera_image_extensions.dart';
import '../../../utils/navigation.dart';
import '../../../utils/throttle.dart';
import '../../logic/unique_settings/best_settings_1.dart';
import '../../logic/unique_settings/best_settings_2.dart';
import '../../logic/unique_settings/best_settings_3.dart';
import '../../logic/unique_settings/best_settings_4.dart';
import '../../logic/unique_settings/best_settings_5.dart';
import '../../logic/unique_settings/best_settings_6.dart';
import '../../logic/unique_settings/best_settings_7.dart';
import '../../logic/unique_settings/best_settings_8.dart';
import '../../logic/unique_settings/best_settings_9.dart';
import '../component/edges_painter.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final EdgeVisionSettings averageBestSettings = [
    bestSettings1,
    bestSettings2,
    bestSettings3,
    bestSettings4,
    bestSettings5,
    bestSettings6,
    bestSettings7,
    bestSettings8,
    bestSettings9,
  ].average();

  late final Future<EdgeVision> edgeVisionFuture = EdgeVision.isolated(settings: {averageSettings}, threads: 4);
  EdgeVision? edgeVision;

  bool cloud = false;

  CameraController? cameraController;

  int imageWidth = 0;
  int imageHeight = 0;

  List<Point<int>> points = [];
  XAxis? xMoveTo;
  YAxis? yMoveTo;

  Future<void> takePicture() async {
    final NavigatorState nav = context.nav;
    final XFile? picture = await cameraController?.takePicture();
    nav.pop(picture);
  }

  Future<void> imageHandler(CameraImage cameraImage) async {
    start('Handling image');
    final Image image = copyRotate(cameraImage.toImage(), angle: 90);
    edgeVision ??= await edgeVisionFuture;
    final Edges edges = await edgeVision!.findImageEdges(image: image);
    imageWidth = edges.originalImageSize?.width ?? image.width;
    imageHeight = edges.originalImageSize?.height ?? image.height;
    xMoveTo = edges.xMoveTo;
    yMoveTo = edges.yMoveTo;
    points = cloud ? edges.allPoints : edges.corners;
    stop('Handling image');
    print('Found ${points.length} points');
    if (mounted && context.mounted) {
      setState(() {});
    }
  }

  Future<void> handleImage(CameraImage cameraImage) async {
    await Throttle.run(
      'handle_image',
      delay: const Duration(milliseconds: 1000 ~/ 30),
      true ? () async => imageHandler(cameraImage) : () => unawaited(imageHandler(cameraImage)),
    );
  }

  Future<void> initCamera() async {
    final List<CameraDescription> cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await cameraController?.initialize();
    await cameraController?.setZoomLevel(1.5);
    await cameraController?.startImageStream(handleImage);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    EdgeVision.logLevel = EdgeVisionLogLevel.nothing;
    unawaited(initCamera());
  }

  @override
  void dispose() {
    unawaited(cameraController?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: takePicture,
            child: Icon(Icons.camera_alt),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => setState(() => cloud = !cloud),
            child: Icon(cloud ? Icons.cloud : Icons.cloud_off_rounded),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: cameraController == null
                  ? Center(
                      child: SizedBox.square(
                        dimension: 50,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CameraPreview(
                      cameraController!,
                    ),
            ),
            if (points.isNotEmpty && imageWidth > 0 && imageHeight > 0)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.yellow.withValues(alpha: 0.15),
                  child: EdgesPainter(
                    points: points,
                    width: imageWidth,
                    height: imageHeight,
                    color: Colors.red,
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    // ⬅️↖️↙️➡️️↗️↘️️⬇️⬆️️⏺️
                    switch ((xMoveTo, yMoveTo)) {
                      (XAxis.left, YAxis.top) => '↖️',
                      (XAxis.left, YAxis.bottom) => '↙️',
                      (XAxis.left, YAxis.center) => '⬅️',
                      (XAxis.right, YAxis.top) => '↗️',
                      (XAxis.right, YAxis.bottom) => '↘️️',
                      (XAxis.right, YAxis.center) => '➡️',
                      (XAxis.center, YAxis.top) => '⬆️',
                      (XAxis.center, YAxis.bottom) => '⬇️',
                      (XAxis.center, YAxis.center) => '⏺️',
                      _ => '',
                    },
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
