import 'dart:math';

extension ExtendedPointNum on Point<num> {
  Point<double> tweenTo(Point<num> newPoint, double t) {
    final num xDiff = newPoint.x - x;
    final num yDiff = newPoint.y - y;

    return Point(x + (xDiff * t), y + (yDiff * t));
  }

  Point<double> toDouble() => Point(x.toDouble(), y.toDouble());
}

extension ExtendedPointNumList on List<Point<num>> {
  List<Point<double>> tweenTo(List<Point<num>> newPoints, double t) {
    if (length != newPoints.length) {
      throw ArgumentError('length of newPoints and old points should be the same');
    }

    final List<Point<double>> results = [];
    for (int i = 0; i < length; i++) {
      results.add(this[i].tweenTo(newPoints[i], t));
    }
    return results;
  }

  List<Point<double>> toDouble() {
    final List<Point<double>> results = [];
    for (int i = 0; i < length; i++) {
      results.add(this[i].toDouble());
    }
    return results;
  }
}
