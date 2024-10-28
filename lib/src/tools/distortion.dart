import '../edge_vision/edges.dart';

/// Calculates the direction to which the camera should be pointed to reduce the degree of distortion of the rectangle edges
Distortion distortion({
  required double topLeft,
  required double topRight,
  required double bottomLeft,
  required double bottomRight,
  required double threshold,
}) {
  final double deltaTopLeft = topLeft - 90;
  final double deltaTopRight = topRight - 90;
  final double deltaBottomLeft = bottomLeft - 90;
  final double deltaBottomRight = bottomRight - 90;

  final double averageLeftDeviation = (deltaTopLeft + deltaBottomLeft) / 2;
  final double averageRightDeviation = (deltaTopRight + deltaBottomRight) / 2;

  final double averageTopDeviation = (deltaTopLeft + deltaTopRight) / 2;
  final double averageBottomDeviation = (deltaBottomLeft + deltaBottomRight) / 2;

  final double horizontalDistortion = averageLeftDeviation - averageRightDeviation;
  final double verticalDistortion = averageTopDeviation - averageBottomDeviation;

  XAxis xAxis = XAxis.center;
  YAxis yAxis = YAxis.center;

  if (horizontalDistortion.abs() > threshold) {
    xAxis = horizontalDistortion > 0 ? XAxis.right : XAxis.left;
  }

  if (verticalDistortion.abs() > threshold) {
    yAxis = verticalDistortion > 0 ? YAxis.bottom : YAxis.top;
  }

  return (x: xAxis, y: yAxis);
}
