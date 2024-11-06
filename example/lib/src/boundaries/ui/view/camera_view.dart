import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:image/image.dart' show Image;

import '../../../utils/bench.dart';
import '../../../utils/camera_image_extensions.dart';
import '../../../utils/navigation.dart';
import '../../../utils/throttle.dart';
import '../component/edges_painter.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final EdgeVision edgeVision = EdgeVision(settings: {averageSettings});

  bool cloud = false;

  CameraController? cameraController;

  int imageWidth = 0;
  int imageHeight = 0;
  List<Point<int>> points = [];

  Future<void> takePicture() async {
    final NavigatorState nav = context.nav;
    final XFile? picture = await cameraController?.takePicture();
    nav.pop(picture);
  }

  Future<void> handleImage(CameraImage cameraImage) async {
    await Throttle.run(
      'handle_image',
      delay: const Duration(milliseconds: 100),
      () async {
        start('Handling image');
        final Image image = cameraImage.toImage();
        imageWidth = image.width;
        imageHeight = image.height;
        final Edges edges = edgeVision.findImageEdges(image: image);
        points = cloud ? edges.allPoints : edges.corners;
        stop('Handling image');
        print('Found ${points.length} points');
        setState(() {});
      },
    );
  }

  Future<void> initCamera() async {
    final List<CameraDescription> cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.low);
    await cameraController?.initialize();
    await cameraController?.startImageStream(handleImage);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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
      body: Stack(
        fit: StackFit.expand,
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
            EdgesPainter(
              points: points,
              width: imageWidth,
              height: imageHeight,
            ),
        ],
      ),
    );
  }
}
