import 'dart:math';

double distance(Point<num> p1, Point<num> p2) => sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));

double distanceDifference(double d1, double d2) {
  final double maxDistance = max(d1, d2);
  final double minDistance = min(d1, d2);

  return (maxDistance - minDistance) / maxDistance;
}
