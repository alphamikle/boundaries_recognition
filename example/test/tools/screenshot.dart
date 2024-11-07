import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:screenshot/screenshot.dart';

Future<img.Image> screenshot({
  required Widget widget,
  double pixelRatio = 1.0,
  Size? size,
}) async {
  final ScreenshotController controller = ScreenshotController();

  Widget target = widget;

  if (size != null) {
    target = SizedBox(
      width: size.width,
      height: size.height,
      child: target,
    );
  }

  final Uint8List bytes = await controller.captureFromWidget(target);
  return img.decodePng(bytes)!;
}
