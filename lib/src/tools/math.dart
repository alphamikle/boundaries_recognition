import 'dart:math';

/// Calculates angle between two lines by three points
double angle(Point<num> start, Point<num> intersection, Point<num> end) {
  final Point<num> ab = Point(intersection.x - start.x, intersection.y - start.y);
  final Point<num> bc = Point(end.x - intersection.x, end.y - intersection.y);

  final num dotProduct = ab.x * bc.x + ab.y * bc.y;

  final double magnitudeAB = sqrt(ab.x * ab.x + ab.y * ab.y);
  final double magnitudeBC = sqrt(bc.x * bc.x + bc.y * bc.y);

  final double cosTheta = dotProduct / (magnitudeAB * magnitudeBC);

  final double angleRadians = acos(cosTheta);

  final double angleDegrees = angleRadians * (180 / pi);

  return angleDegrees;
}

/// Calculates distance between two points
double distance(Point<num> p1, Point<num> p2) => sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));

/// Calculates the percentage difference between two numbers
double percentageDifference(double d1, double d2) {
  final double maxNumber = max(d1, d2);
  final double minNumber = min(d1, d2);

  return (maxNumber - minNumber) / maxNumber;
}

/// Calculates square of some area. Mostly - area of the recognized object
int square(Point<num> p1, Point<num> p2, Point<num> p3, Point<num> p4) {
  final num sum1 = p1.x * p2.y + p2.x * p3.y + p3.x * p4.y + p4.x * p1.y;
  final num sum2 = p1.y * p2.x + p2.y * p3.x + p3.y * p4.x + p4.y * p1.x;
  return (sum1 - sum2).abs() ~/ 2;
}
