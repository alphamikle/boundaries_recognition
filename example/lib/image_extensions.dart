import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as i;

extension ExtendedImage on i.Image {
  i.Image rotateWithOrientation(DeviceOrientation orientation) {
    switch (orientation) {
      case DeviceOrientation.portraitUp:
        return this;
      case DeviceOrientation.landscapeLeft:
        return i.copyRotate(this, angle: 90);
      case DeviceOrientation.portraitDown:
        return i.copyRotate(this, angle: 180);
      case DeviceOrientation.landscapeRight:
        return i.copyRotate(this, angle: -90);
    }
  }

  i.Image rotateWithController(CameraController controller) {
    final int angle = _calculateRotationAngle(controller);
    return i.copyRotate(this, angle: angle);
  }

  int _calculateRotationAngle(CameraController controller) {
    final DeviceOrientation deviceOrientation = controller.value.deviceOrientation;
    final int sensorOrientation = controller.description.sensorOrientation;

    int rotationAngle;
    switch (deviceOrientation) {
      case DeviceOrientation.portraitUp:
        rotationAngle = sensorOrientation;
        break;
      case DeviceOrientation.landscapeLeft:
        rotationAngle = (sensorOrientation - 90) % 360;
        break;
      case DeviceOrientation.portraitDown:
        rotationAngle = (sensorOrientation - 180) % 360;
        break;
      case DeviceOrientation.landscapeRight:
        rotationAngle = (sensorOrientation - 270) % 360;
        break;
      default:
        rotationAngle = 0;
    }

    if (rotationAngle < 0) {
      rotationAngle += 360;
    }

    return rotationAngle;
  }

  // TODO(alphamikle): May be buggy
  /// Image converter to black and white only pixels
  i.Image toBlackWhite(int threshold) {
    final i.Image image = i.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final i.Pixel pixel = getPixel(x, y);
        final num brightness = i.getLuminance(pixel);

        if (brightness > threshold) {
          image.setPixel(x, y, i.ColorInt8.rgb(255, 255, 255));
        } else {
          image.setPixel(x, y, i.ColorInt8.rgb(0, 0, 0));
        }
      }
    }
    return image;
  }
}
