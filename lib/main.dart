import 'dart:async';
import 'dart:math';

import 'package:boundaries_detector/boundaries_drawer.dart';
import 'package:boundaries_detector/boundaries_finder.dart';
import 'package:boundaries_detector/settings.dart';
import 'package:boundaries_detector/threshold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as i;

/*
Pretty good results without isles
GA: 6.25
SA: 1.25
C-TH: 253
S-TH: 10
 */

final Map<String, int> _benchKeys = {};

void start(String id) => _benchKeys[id] = DateTime.now().microsecondsSinceEpoch;

void stop(
  String id, {
  bool clear = false,
}) {
  final int? start = _benchKeys[id];
  if (start == null) {
    return;
  }

  final int now = DateTime.now().microsecondsSinceEpoch;

  print('$id: ${(now - start) / 1000}ms');

  if (clear) {
    _benchKeys.remove(id);
  }
}

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
  String get size => '300_400';
  bool get usePieces => false;

  Uint8List? image;
  Uint8List? imageWithFilters;
  bool showFilters = false;
  bool showPainter = false;
  bool onlyCorners = false;

  List<Point<int>> points = [];
  int? width;
  int? height;

  Timer? applyTimer;

  Settings settings = const Settings(
    grayscale: FilterSettings(
      amount: 1,
      maskChannel: 0,
    ),
    sobel: FilterSettings(
      amount: 1,
      maskChannel: 0,
    ),
    colorThreshold: 128,
    searchThreshold: 1,
  );

  void applySettings(Settings settings) {
    setState(() => this.settings = settings);
    applyTimer?.cancel();
    applyTimer = Timer(const Duration(milliseconds: 750), applyFilters);
  }

  void applyFilters() {
    final Uint8List? image = this.image;

    if (image == null) {
      return;
    }

    start('Filters');

    i.Image? imageToProcess = i.decodeJpg(image);

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

    final Boundaries boundaries = findBoundaries(imageToProcess);
    points = onlyCorners ? boundaries.corners : boundaries.allPoints;

    print('Found ${boundaries.allPoints} points!');

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

  Future<void> loadImage() async {
    final ByteData bytes = await rootBundle.load(usePieces ? 'assets/pieces_$size/00.jpg' : 'assets/card_$size.jpg');
    image = bytes.buffer.asUint8List();
    imageWithFilters = bytes.buffer.asUint8List();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: image == null && imageWithFilters == null
                ? const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Image.memory(
                        showFilters ? imageWithFilters! : image!,
                        fit: BoxFit.cover,
                      ),
                      if (showPainter && points.isNotEmpty && width != null && height != null)
                        Positioned.fill(
                          child: ColoredBox(
                            color: Colors.yellow.withOpacity(0.15),
                          ),
                        ),
                      if (showPainter && points.isNotEmpty && width != null && height != null)
                        Positioned.fill(
                          child: BoundariesDrawer(
                            points: points,
                            width: width!,
                            height: height!,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: toggleFilters,
                  child: Text(
                    showFilters ? 'Filters -' : 'Filters +',
                  ),
                ),
                TextButton(
                  onPressed: togglePainter,
                  child: Text(
                    showPainter ? 'Painter -' : 'Painter +',
                  ),
                ),
                TextButton(
                  onPressed: toggleCorners,
                  child: Text(
                    onlyCorners ? 'Corners -' : 'Corners +',
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
