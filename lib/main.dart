import 'dart:async';
import 'dart:math';

import 'package:boundaries_detector/boundaries_drawer.dart';
import 'package:boundaries_detector/boundaries_finder.dart';
import 'package:boundaries_detector/settings.dart';
import 'package:boundaries_detector/threshold.dart';
import 'package:boundaries_detector/utils/convert_image.dart';
import 'package:boundaries_detector/utils/distortion.dart';
import 'package:boundaries_detector/utils/throttle.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as i;

import 'utils/bench.dart';

/*
Pretty good results without isles
GA: 6.25
SA: 1.25
C-TH: 150
S-TH: 3
Size: 40
Angle: 2.20
 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boundaries',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController scrollController = ScrollController();
  CameraController? cameraController;

  String get size => '300_400';
  // wipes_and_card_240_320_v2.jpg
  // wipes_240_320_v1.jpg
  String? get imagePath => true ? 'wipes_and_card_240_320_v2.jpg' : null;
  bool get usePieces => false;
  bool get useCamera => true;

  Uint8List? image;
  Uint8List? imageWithFilters;
  i.Image? convertedImage;

  bool showFilters = false;
  bool showPainter = true;
  bool onlyCorners = true;

  List<Point<int>> points = [];
  XAxis xMoveTo = XAxis.center;
  YAxis yMoveTo = YAxis.center;
  int? width;
  int? height;

  Timer? applyTimer;

  Settings settings = const Settings(
    grayscale: FilterSettings(
      amount: 6.25,
      maskChannel: 0,
    ),
    sobel: FilterSettings(
      amount: 1.25,
      maskChannel: 0,
    ),
    colorThreshold: 150,
    searchThreshold: 3,
    groupSize: 40,
    angle: 2.20,
  );

  void applySettings(Settings settings) {
    setState(() => this.settings = settings);
    applyTimer?.cancel();
    applyTimer = Timer(const Duration(milliseconds: 750), applyFilters);
  }

  void applyFilters() {
    final Uint8List? image = this.image;
    final i.Image? convertedImage = this.convertedImage;

    if (image == null && convertedImage == null) {
      return;
    }

    start('Filters');

    i.Image? imageToProcess = convertedImage ?? i.decodeJpg(image!);

    if (imageToProcess == null) {
      return;
    }

    width = imageToProcess.width;
    height = imageToProcess.height;

    imageToProcess = i.grayscale(imageToProcess, amount: settings.grayscale.amount, maskChannel: i.Channel.values[settings.grayscale.maskChannel]);
    imageToProcess = i.sobel(imageToProcess, amount: settings.sobel.amount, maskChannel: i.Channel.values[settings.sobel.maskChannel]);

    if (settings.colorThreshold > 0 && settings.colorThreshold < 255) {
      threshold(imageToProcess, settings.colorThreshold);
    }

    stop('Filters', clear: true);

    start('Boundaries');

    final Boundaries boundaries = findBoundaries(
      imageToProcess,
      matrixSize: settings.searchThreshold,
      minSize: settings.groupSize,
      angleThreshold: settings.angle,
    );
    points = onlyCorners ? boundaries.corners : boundaries.allPoints;

    print('Image size: [$width x $height]; Found ${boundaries.allPoints.length} points in the largest object and ${boundaries.recognizedObjects} objects');

    xMoveTo = boundaries.xMoveTo;
    yMoveTo = boundaries.yMoveTo;

    stop('Boundaries', clear: true);

    imageWithFilters = i.encodeJpg(imageToProcess);

    setState(() {});
  }

  void toggleFilters() {
    if (showFilters) {
      setState(() => showFilters = false);
      return;
    }

    applyFilters();

    setState(() => showFilters = true);
  }

  void togglePainter() {
    if (width == null || height == null || points.isEmpty) {
      return;
    }

    setState(() => showPainter = !showPainter);
  }

  void toggleCorners() {
    if (width == null || height == null) {
      return;
    }
    setState(() => onlyCorners = !onlyCorners);
    applyTimer = Timer(const Duration(milliseconds: 750), applyFilters);
  }

  Future<void> handleImage(CameraImage cameraImage) async {
    Throttle.run('handle_image', () async {
      convertedImage = convertToImage(cameraImage);
      applyFilters();
    });
  }

  Future<void> loadImage() async {
    final ByteData bytes = await rootBundle.load(
      imagePath == null
          ? usePieces
              ? 'assets/pieces_$size/00.jpg'
              : 'assets/card_$size.jpg'
          : 'assets/$imagePath',
    );
    image = bytes.buffer.asUint8List();
    imageWithFilters = bytes.buffer.asUint8List();
    setState(() {});
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.low);
    await cameraController?.initialize();
    cameraController?.startImageStream(handleImage);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (useCamera) {
      initCamera();
    } else {
      loadImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        key: const PageStorageKey('list_view'),
        // controller: scrollController,
        children: [
          Expanded(
            child: useCamera && cameraController == null || useCamera == false && image == null
                ? const Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Stack(
                    fit: StackFit.passthrough,
                    children: [
                      useCamera
                          ? CameraPreview(cameraController!)
                          : Image.memory(
                              showFilters ? imageWithFilters! : image!,
                              fit: BoxFit.cover,
                            ),
                      if (showPainter && points.isNotEmpty && width != null && height != null)
                        Positioned.fill(
                          child: BoundariesDrawer(
                            points: points,
                            width: width!,
                            height: height!,
                          ),
                        ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
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
                              },
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          Slider(
            value: settings.grayscale.amount,
            onChanged: (double value) => applySettings(settings.change(grayscaleAmount: value)),
            min: 0,
            max: 10,
            divisions: 40,
            label: 'GA: ${settings.grayscale.amount.toStringAsFixed(2)}',
          ),
          Slider(
            value: settings.grayscale.maskChannel.toDouble(),
            onChanged: (double value) => applySettings(settings.change(grayscaleMaskChannel: value.toInt())),
            min: 0,
            max: (i.Channel.values.length - 1).toDouble(),
            divisions: i.Channel.values.length - 1,
            label: 'GM: ${settings.grayscale.maskChannel.toStringAsFixed(0)}',
          ),
          Slider(
            value: settings.sobel.amount,
            onChanged: (double value) => applySettings(settings.change(sobelAmount: value)),
            min: 0,
            max: 10,
            divisions: 40,
            label: 'SA: ${settings.sobel.amount.toStringAsFixed(2)}',
          ),
          Slider(
            value: settings.sobel.maskChannel.toDouble(),
            onChanged: (double value) => applySettings(settings.change(sobelMaskChannel: value.toInt())),
            min: 0,
            max: (i.Channel.values.length - 1).toDouble(),
            divisions: i.Channel.values.length - 1,
            label: 'SM: ${settings.sobel.maskChannel.toStringAsFixed(0)}',
          ),
          Slider(
            value: settings.colorThreshold.toDouble(),
            onChanged: (double value) => applySettings(settings.change(colorThreshold: value.toInt())),
            min: 0,
            max: 255,
            divisions: 254,
            label: 'C-TH: ${settings.colorThreshold.toStringAsFixed(0)}',
          ),
          Slider(
            value: settings.searchThreshold.toDouble(),
            onChanged: (double value) => applySettings(settings.change(searchThreshold: value.toInt())),
            min: 1,
            max: 25,
            divisions: 24,
            label: 'S-TH: ${settings.searchThreshold.toStringAsFixed(0)}',
          ),
          Slider(
            value: settings.groupSize.toDouble(),
            onChanged: (double value) => applySettings(settings.change(groupSize: value.toInt())),
            min: 1,
            max: 100,
            divisions: 98,
            label: 'Size: ${settings.groupSize.toStringAsFixed(0)}',
          ),
          Slider(
            value: settings.angle.toDouble(),
            onChanged: (double value) => applySettings(settings.change(angle: value)),
            min: 0,
            max: 5,
            divisions: 25,
            label: 'Angle: ${settings.angle.toStringAsFixed(2)}',
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (useCamera == false)
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
