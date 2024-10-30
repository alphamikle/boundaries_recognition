import 'dart:math';

import 'package:flutter/material.dart';

class EdgesPainter extends StatelessWidget {
  const EdgesPainter({
    required this.points,
    required this.width,
    required this.height,
    super.key,
  });

  final List<Point<int>> points;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(
        points: points,
        width: width,
        height: height,
      ),
    );
  }
}

class _Painter extends CustomPainter {
  const _Painter({
    required this.points,
    required this.width,
    required this.height,
  });

  final List<Point<int>> points;
  final int width;
  final int height;

  Offset pointToOffset(Point<int> point, Size size) {
    final double xM = size.width / width;
    final double yM = size.height / height;

    return Offset(
      point.x * xM,
      point.y * yM,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    if (points.length < 4) {
      return;
    }

    Offset previousPoint = pointToOffset(points.first, size);

    for (int i = 1; i < points.length; i++) {
      final Offset currentPoint = pointToOffset(points[i], size);

      canvas.drawLine(previousPoint, currentPoint, paint);
      previousPoint = currentPoint;
    }

    canvas.drawLine(previousPoint, pointToOffset(points.first, size), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
