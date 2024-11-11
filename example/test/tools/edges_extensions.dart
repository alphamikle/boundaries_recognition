import 'dart:math';

import 'package:edge_vision/edge_vision.dart';

extension ExtendedEdges on Edges {
  bool isSimilarWith(Edges other, int threshold) {
    if (corners.isEmpty || other.corners.isEmpty) {
      return false;
    }
    if (this == other) {
      return true;
    }
    final bool isLeftTopSimilar = leftTop!.isSimilarWith(other.leftTop!, threshold);
    if (isLeftTopSimilar == false) {
      return false;
    }

    final bool isRightTopSimilar = rightTop!.isSimilarWith(other.rightTop!, threshold);
    if (isRightTopSimilar == false) {
      return false;
    }

    final bool isRightBottomSimilar = rightBottom!.isSimilarWith(other.rightBottom!, threshold);
    if (isRightBottomSimilar == false) {
      return false;
    }
    return leftBottom!.isSimilarWith(other.leftBottom!, threshold);
  }
}

extension _ExtendedPointInt on Point<int> {
  bool isSimilarWith(Point<int> other, int threshold) {
    final int xMax = max(x, other.x);
    final int xMin = min(x, other.x);
    final int xDiff = xMax - xMin;
    if (xDiff > threshold) {
      return false;
    }

    final int yMax = max(y, other.y);
    final int yMin = min(y, other.y);
    final int yDiff = yMax - yMin;
    return yDiff <= threshold;
  }
}
