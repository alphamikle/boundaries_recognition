import 'package:edge_vision/edge_vision.dart';

const EdgeVisionSettings initialSettings = EdgeVisionSettings(
  searchMatrixSize: 3,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 0.1,
  skewnessThreshold: 0.15,
  blackWhiteThreshold: 60,
  sobelLevel: 0.2,
  sobelAmount: 1,
  blurRadius: 1,
  areaThreshold: 0.35,
  luminanceThreshold: 1.05,
  maxImageSize: 400, // Do not resize during the tests
);

const EdgeVisionSettings targetSettings = EdgeVisionSettings.zero(
  blackWhiteThreshold: 180,
  sobelLevel: 4,
  sobelAmount: 4,
  luminanceThreshold: 1.25,
  blurRadius: 3,
);

const EdgeVisionSettings stepSettings = EdgeVisionSettings.zero(
  blackWhiteThreshold: 20,
  sobelLevel: 0.25,
  sobelAmount: 1,
  luminanceThreshold: 0.1,
  blurRadius: 1,
);
