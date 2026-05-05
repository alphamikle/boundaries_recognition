import 'package:edge_vision/edge_vision.dart';

const EdgeVisionSettings bestSettings7 = EdgeVisionSettings(
  searchMatrixSize: 3,
  minObjectSize: 40,
  directionAngleLevel: 3.0,
  symmetricAngleThreshold: 0.125,
  skewnessThreshold: 0.125,
  blackWhiteThreshold: 130,
  sobelLevel: 1.0,
  sobelAmount: 1,
  blurRadius: 3,
  areaThreshold: 0.3,
  luminanceThreshold: 1.15,
  maxImageSize: 1000,
  grayscaleLevel: 0.2,
  grayscaleAmount: 0,
);
