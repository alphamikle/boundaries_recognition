import 'package:edge_vision/edge_vision.dart';

const EdgeVisionSettings initialSettings = EdgeVisionSettings(
  searchMatrixSize: 3,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 0.1,
  skewnessThreshold: 0.15,
  blackWhiteThreshold: 1,
  grayscaleLevel: 0.25,
  grayscaleAmount: 1,
  sobelLevel: 0.25,
  sobelAmount: 1,
  blurRadius: 2,
  areaThreshold: 0.65,
);

const EdgeVisionSettings endSettings = EdgeVisionSettings.zero(
  blackWhiteThreshold: 254,
  grayscaleLevel: 7,
  grayscaleAmount: 5,
  sobelLevel: 7,
  sobelAmount: 5,
);

const EdgeVisionSettings stepSettings = EdgeVisionSettings.zero(
  blackWhiteThreshold: 5,
  grayscaleLevel: 0.25,
  grayscaleAmount: 1,
  sobelLevel: 0.25,
  sobelAmount: 1,
);
