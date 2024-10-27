import 'dart:math';

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
