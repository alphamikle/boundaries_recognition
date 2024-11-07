import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

/// Captures the given widget as an image and returns it as an `img.Image` (from the `image` package).
/// This method builds the widget, captures it as a `ui.Image`, and then converts it to `img.Image`.
Future<img.Image> widgetToImage({
  required WidgetTester tester,
  required Widget widget,
  double pixelRatio = 1.0,
}) async {
  // Create a GlobalKey for the RepaintBoundary
  final GlobalKey repaintBoundaryKey = GlobalKey();

  print('Before pumping');

  // Wrap the widget in a RepaintBoundary and build it in a MaterialApp
  await tester.pumpWidget(
    SizedBox(
      height: 1000,
      width: 3000,
      child: MaterialApp(
        home: Scaffold(
          body: RepaintBoundary(
            key: repaintBoundaryKey,
            child: widget,
          ),
        ),
      ),
    ),
  );

  print('Pumped');

  // Wait for the widget to be fully rendered
  await tester.pumpAndSettle();

  print('Settled');

  // Retrieve the RenderRepaintBoundary from the context
  final RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

  // Capture the widget as a ui.Image
  final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

  print('Converted to image');

  // Convert ui.Image to PNG bytes
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  final Uint8List bytes = byteData!.buffer.asUint8List();

  print('Got bytes [${bytes.length}] from image');

  // Decode the PNG bytes to an image from the `image` package
  return img.decodePng(bytes)!;
}
