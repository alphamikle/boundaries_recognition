import 'dart:math';

typedef PointCoordinates<T extends num> = ({num x, num y});

extension ExtendedIntPoint on Point<int> {
  int get ltSum => x + y;
  int get rtSum => x - y;
  int get rbSum => ltSum;
  int get lbSum => y - x;

  bool isInRectangle(int width, int height) => x >= 0 && y >= 0 && x < width && y < height;
}

extension ExtendedPointCoordinates<T extends num> on PointCoordinates<T> {
  bool isInRectangle(int width, int height) => x >= 0 && y >= 0 && x < width && y < height;
}
