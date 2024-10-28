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

/// Calculates the percentage difference between the lengths of two lines
double distanceDifference(double d1, double d2) {
  final double maxDistance = max(d1, d2);
  final double minDistance = min(d1, d2);

  return (maxDistance - minDistance) / maxDistance;
}
