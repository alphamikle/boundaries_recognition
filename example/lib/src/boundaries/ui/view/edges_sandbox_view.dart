import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as i;

import '../../../utils/bench.dart';
import '../../../utils/camera_image_extensions.dart';
import '../../../utils/throttle.dart';
import '../../logic/bloc/edges_bloc.dart';
import '../component/edges_painter.dart';

class EdgesSandboxView extends StatefulWidget {
  const EdgesSandboxView({
    super.key,
  });

  @override
  State<EdgesSandboxView> createState() => _EdgesSandboxViewState();
}

class _EdgesSandboxViewState extends State<EdgesSandboxView> {
  late final EdgesBloc edgesBloc = context.read();

  Future<void> init() async {
    await edgesBloc.loadImage('i1_small');
    await edgesBloc.loadImage('i2_small');
    await edgesBloc.loadImage('i3_small');
    await edgesBloc.loadImage('i4_small');
  }

  // Future<void> handleImage(CameraImage cameraImage) async {
  //   await Throttle.run(
  //     'handle_image',
  //     () async {
  //       this.cameraImage = cameraImage.toImage();
  //       orientation = cameraController?.value.deviceOrientation;
  //       await applyFilters();
  //     },
  //   );
  // }
  //
  // Future<void> initCamera() async {
  //   final cameras = await availableCameras();
  //   cameraController = CameraController(cameras[0], ResolutionPreset.low);
  //   await cameraController?.initialize();
  //   await cameraController?.startImageStream(handleImage);
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    unawaited(init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// @ Settings
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TODO(alphamikle): Continue here
                  Slider(
                    value: settings.grayscaleAmount,
                    onChanged: (double value) => applySettings(settings.copyWith(grayscaleAmount: value)),
                    max: 10,
                    divisions: 40,
                    label: 'GA: ${settings.grayscaleAmount.toStringAsFixed(2)}',
                  ),
                  Slider(
                    value: settings.sobelAmount,
                    onChanged: (double value) => applySettings(settings.copyWith(sobelAmount: value)),
                    max: 10,
                    divisions: 40,
                    label: 'SA: ${settings.sobelAmount.toStringAsFixed(2)}',
                  ),
                  Slider(
                    value: settings.blackWhiteThreshold.toDouble(),
                    onChanged: (double value) => applySettings(settings.copyWith(blackWhiteThreshold: value.toInt())),
                    max: 255,
                    divisions: 254,
                    label: 'C-TH: ${settings.blackWhiteThreshold.toStringAsFixed(0)}',
                  ),
                  Slider(
                    value: settings.searchMatrixSize.toDouble(),
                    onChanged: (double value) => applySettings(settings.copyWith(searchMatrixSize: value.toInt())),
                    min: 1,
                    max: 25,
                    divisions: 24,
                    label: 'S-TH: ${settings.searchMatrixSize.toStringAsFixed(0)}',
                  ),
                  Slider(
                    value: settings.minObjectSize.toDouble(),
                    onChanged: (double value) => applySettings(settings.copyWith(minObjectSize: value.toInt())),
                    min: 1,
                    max: 100,
                    divisions: 98,
                    label: 'Size: ${settings.minObjectSize.toStringAsFixed(0)}',
                  ),
                  Slider(
                    value: settings.distortionAngleThreshold.toDouble(),
                    onChanged: (double value) => applySettings(settings.copyWith(distortionAngleThreshold: value)),
                    max: 5,
                    divisions: 25,
                    label: 'Angle: ${settings.distortionAngleThreshold.toStringAsFixed(2)}',
                  ),
                  Slider(
                    value: settings.skewnessThreshold.toDouble(),
                    onChanged: (double value) => applySettings(settings.copyWith(skewnessThreshold: value)),
                    max: 0.5,
                    divisions: 25,
                    label: 'P-TH: ${settings.skewnessThreshold.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
          ),

          /// @ Buttons
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: toggleFilters,
                  child: Text(
                    showFilters ? 'Filters ✅️' : 'Filters ⬜️',
                  ),
                ),
                TextButton(
                  onPressed: togglePainter,
                  child: Text(
                    showPainter ? 'Paint ✅️' : 'Paint ⬜️',
                  ),
                ),
                TextButton(
                  onPressed: toggleCorners,
                  child: Text(
                    onlyCorners ? 'Corners ✅️' : 'Corners ⬜️',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
