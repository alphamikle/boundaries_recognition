import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as i;

i.Image fixRotation(i.Image image, DeviceOrientation orientation) {
  switch (orientation) {
    case DeviceOrientation.portraitUp:
      return image;
    case DeviceOrientation.landscapeLeft:
      return i.copyRotate(image, angle: 90);
    case DeviceOrientation.portraitDown:
      return i.copyRotate(image, angle: 180);
    case DeviceOrientation.landscapeRight:
      return i.copyRotate(image, angle: -90);
  }
}

i.Image fixRotationV2(i.Image image, CameraController controller) {
  final int angle = _calculateRotationAngle(controller);
  return i.copyRotate(image, angle: angle);
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
