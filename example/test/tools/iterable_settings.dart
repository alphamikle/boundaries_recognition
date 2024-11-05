import 'package:edge_vision/edge_vision.dart';

const EdgeVisionSettings initialSettings = EdgeVisionSettings(
  searchMatrixSize: 3,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 0.1,
  skewnessThreshold: 0.15,
  blackWhiteThreshold: 1,
  grayscaleLevel: 0.1, // Grayscale Disabled => Best Channel Enabled
  grayscaleAmount: 0,
  sobelLevel: 0.2,
  sobelAmount: 1,
  blurRadius: 1,
  areaThreshold: 0.35,
  luminanceThreshold: 1.05,
);

const EdgeVisionSettings targetSettings = EdgeVisionSettings.zero(
  blackWhiteThreshold: 254,
  sobelLevel: 7,
  sobelAmount: 5,
  luminanceThreshold: 1.5,
  blurRadius: 4,
);

const EdgeVisionSettings stepSettings = EdgeVisionSettings.zero(
  blackWhiteThreshold: 10,
  sobelLevel: 0.2,
  sobelAmount: 1,
  luminanceThreshold: 0.05,
  blurRadius: 1,
);
