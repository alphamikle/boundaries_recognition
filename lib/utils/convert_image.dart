import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

img.Image convertToImage(CameraImage cameraImage) {
  final int width = cameraImage.width;
  final int height = cameraImage.height;

  final img.Image image = img.Image(width: width, height: height);

  final Uint8List y = cameraImage.planes[0].bytes;
  final Uint8List u = cameraImage.planes[1].bytes;
  final Uint8List v = cameraImage.planes[2].bytes;

  final int uvRowStride = cameraImage.planes[1].bytesPerRow;
  final int uvPixelStride = cameraImage.planes[1].bytesPerPixel ?? 1;

  for (int yRow = 0; yRow < height; yRow++) {
    for (int yCol = 0; yCol < width; yCol++) {
      final int uvIndex = (yRow ~/ 2) * uvRowStride + (yCol ~/ 2) * uvPixelStride;

      final int yValue = y[yRow * width + yCol];
      final int uValue = u[uvIndex];
      final int vValue = v[uvIndex];

      int r = (yValue + 1.402 * (vValue - 128)).toInt();
      int g = (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128)).toInt();
      int b = (yValue + 1.772 * (uValue - 128)).toInt();

      r = r.clamp(0, 255);
      g = g.clamp(0, 255);
      b = b.clamp(0, 255);

      image.setPixelRgb(yCol, yRow, r, g, b);
    }
  }

  return image;
}
