import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as i;

import 'bench.dart';
import 'boundaries_drawer.dart';
import 'camera_image_extensions.dart';
import 'throttle.dart';

/*
Pretty good results without isles
GA: 1.00 for light background and 6.25 for dark
SA: 1.25
C-TH: 150
S-TH: 3
Size: 40
Angle: 5.00
P-TH: 0.26
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
  final EdgeVision edgeVision = EdgeVision(threads: 1);
  CameraController? cameraController;

  String? get imagePath => 'i3_small';
  int get maxSize => 500;
  int get threads => 1;
  bool get useCamera => true;

  Uint8List? image;
  Uint8List? filtersImage;
  Uint8List? customFiltersImage;
  i.Image? cameraImage;

  DeviceOrientation? orientation;

  bool showFilters = false;
  bool showPainter = true;
  bool onlyCorners = true;

  List<Point<int>> points = [];
  XAxis xMoveTo = XAxis.center;
  YAxis yMoveTo = YAxis.center;
  int? width;
  int? height;

  bool grayscaleApplied = false;
  bool blurApplied = false;
  bool resized = false;
  bool sobelApplied = false;
  bool blackAndWhiteApplied = false;

  bool get customFiltersApplied => grayscaleApplied || blurApplied || resized || sobelApplied || blackAndWhiteApplied;

  Timer? applyTimer;

  Settings settings = const Settings(
    blackWhiteThreshold: 150,
    blurRadius: 2,
    distortionAngleThreshold: 5,
    grayscaleAmount: 1.00,
    minObjectSize: 40,
    searchMatrixSize: 3,
    skewnessThreshold: 0.26,
    sobelAmount: 1.25,
  );

  void applySettings(Settings settings) {
    setState(() => this.settings = settings);
    applyTimer?.cancel();
    applyTimer = Timer(const Duration(milliseconds: 400), applyFilters);
  }

  void applyCustomFilter({
    bool? grayscaleApplied,
    bool? blurApplied,
    bool? resized,
    bool? sobelApplied,
    bool? blackAndWhiteApplied,
  }) {
    if (this.image == null) {
      return;
    }

    if (grayscaleApplied != null) {
      this.grayscaleApplied = grayscaleApplied;
    }
    if (blurApplied != null) {
      this.blurApplied = blurApplied;
    }
    if (resized != null) {
      this.resized = resized;
    }
    if (sobelApplied != null) {
      this.sobelApplied = sobelApplied;
    }
    if (blackAndWhiteApplied != null) {
      this.blackAndWhiteApplied = blackAndWhiteApplied;
    }

    i.Image image = i.decodeJpg(this.image!)!;

    if (this.resized) {
      final int largeSize = max(image.width, image.height);
      if (largeSize >= maxSize) {
        final int smallSize = min(image.width, image.height);
        final int delimiter = largeSize ~/ maxSize;

        final int newLargeSize = maxSize;
        final int newSmallSize = smallSize ~/ delimiter;

        final bool isPortrait = image.height >= image.width;

        image = image.resize(isPortrait ? newSmallSize : newLargeSize, isPortrait ? newLargeSize : newSmallSize);
      }
    }
    if (this.grayscaleApplied) {
      image = i.grayscale(image, amount: settings.grayscaleAmount);
    }
    if (this.blurApplied) {
      image = i.gaussianBlur(image, radius: settings.blurRadius);
    }
    if (this.sobelApplied) {
      image = i.sobel(image, amount: settings.sobelAmount);
    }
    if (this.blackAndWhiteApplied) {
      image = image.toBlackWhite(settings.blackWhiteThreshold);
    }

    if (customFiltersApplied) {
      customFiltersImage = i.encodeJpg(image);
    } else {
      customFiltersImage = null;
    }

    setState(() {});
  }

  Future<void> applyFilters() async {
    if (customFiltersApplied) {
      applyCustomFilter();
    }

    final Uint8List? image = this.image;
    final i.Image? cameraImage = this.cameraImage;

    if (image == null && cameraImage == null && customFiltersImage == null) {
      return;
    }

    i.Image? imageToProcess = customFiltersImage == null ? cameraImage ?? i.decodeJpg(image!) : i.decodeJpg(customFiltersImage!);

    if (imageToProcess == null) {
      return;
    }

    if (customFiltersApplied == false) {
      if (max(imageToProcess.width, imageToProcess.height) > maxSize) {
        start('Resizing');
        final int largeSize = max(imageToProcess.width, imageToProcess.height);
        final int smallSize = min(imageToProcess.width, imageToProcess.height);
        final int delimiter = largeSize ~/ maxSize;

        final int newLargeSize = maxSize;
        final int newSmallSize = smallSize ~/ delimiter;

        final bool isPortrait = imageToProcess.height >= imageToProcess.width;

        imageToProcess = imageToProcess.resize(isPortrait ? newSmallSize : newLargeSize, isPortrait ? newLargeSize : newSmallSize);
        stop('Resizing');
      }

      if (orientation != null && orientation != DeviceOrientation.portraitUp && cameraController != null) {
        start('Rotating 1');
        imageToProcess = imageToProcess.rotateWithController(cameraController!);
        stop('Rotating 1');
      }

      final double aspectRatio = imageToProcess.width / imageToProcess.height;
      if (aspectRatio > 1) {
        start('Rotating 2');
        imageToProcess = i.copyRotate(imageToProcess, angle: 90);
        stop('Rotating 2');
      }

      width = imageToProcess.width;
      height = imageToProcess.height;
      imageToProcess = await edgeVision.prepareImage(image: imageToProcess, settings: settings);
      filtersImage = i.encodeJpg(imageToProcess);
    }

    final Edges edges = await edgeVision.findImageEdges(image: imageToProcess, settings: settings, preparedImage: true);

    points = onlyCorners ? edges.corners : edges.allPoints;

    dev.log('Image size: [$width x $height]; Found ${edges.allPoints.length} points in the largest object and ${edges.recognizedObjects} objects');

    xMoveTo = edges.xMoveTo;
    yMoveTo = edges.yMoveTo;

    setState(() {});
  }

  Future<void> toggleFilters() async {
    if (showFilters) {
      setState(() => showFilters = false);
      return;
    }

    await applyFilters();

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
  }

  Future<void> handleImage(CameraImage cameraImage) async {
    await Throttle.run(
      'handle_image',
      () async {
        this.cameraImage = cameraImage.toImage();
        orientation = cameraController?.value.deviceOrientation;
        await applyFilters();
      },
    );
  }

  Future<void> loadImage() async {
    final ByteData bytes = await rootBundle.load('assets/$imagePath.jpg');
    image = bytes.buffer.asUint8List();
    filtersImage = bytes.buffer.asUint8List();
    setState(() {});
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.low);
    await cameraController?.initialize();
    await cameraController?.startImageStream(handleImage);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (useCamera) {
      unawaited(initCamera());
    } else {
      unawaited(loadImage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// ? Camera view or Image view
          AspectRatio(
            aspectRatio: 3 / 4,
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
                      if (showFilters)
                        Image.memory(filtersImage!)
                      else
                        useCamera
                            ? CameraPreview(cameraController!)
                            : Image.memory(
                                customFiltersImage == null ? image! : customFiltersImage!,
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

          /// @ Settings
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => applyCustomFilter(grayscaleApplied: !grayscaleApplied),
                          child: Text(grayscaleApplied ? 'Gray ✅️' : 'Gray ⬜️'),
                        ),
                        TextButton(
                          onPressed: () => applyCustomFilter(blurApplied: !blurApplied),
                          child: Text(blurApplied ? 'Blur ✅️' : 'Blur ⬜️'),
                        ),
                        TextButton(
                          onPressed: () => applyCustomFilter(resized: !resized),
                          child: Text(resized ? 'Small ✅️' : 'Small ⬜️'),
                        ),
                        TextButton(
                          onPressed: () => applyCustomFilter(sobelApplied: !sobelApplied),
                          child: Text(sobelApplied ? 'Sobel ✅️' : 'Sobel ⬜️'),
                        ),
                        TextButton(
                          onPressed: () => applyCustomFilter(blackAndWhiteApplied: !blackAndWhiteApplied),
                          child: Text(blackAndWhiteApplied ? 'B/W ✅️' : 'B/W ⬜️'),
                        ),
                      ],
                    ),
                  ),
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
