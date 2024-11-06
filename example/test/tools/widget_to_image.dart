import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as i;
import 'package:image/image.dart';

Future<i.Image> widgetToImage(Widget widget, {double pixelRatio = 1.0}) async {
  final GlobalKey repaintBoundaryKey = GlobalKey();

  final RepaintBoundary widgetWithBoundary = RepaintBoundary(
    key: repaintBoundaryKey,
    child: MaterialApp(
      home: Scaffold(
        body: Center(
          child: widget,
        ),
      ),
    ),
  );

  final RenderRepaintBoundary boundary = await _renderBoundary(widgetWithBoundary, repaintBoundaryKey);

  final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
  final Uint8List bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  return decodePng(bytes)!;
}

Future<RenderRepaintBoundary> _renderBoundary(Widget widget, GlobalKey boundaryKey) async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  // binding.renderViews.first.attach(binding.rootPipelineOwner);
  binding.scheduleFrame();
  await binding.endOfFrame;
  return boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
}
