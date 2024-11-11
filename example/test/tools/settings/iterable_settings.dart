import 'package:edge_vision/edge_vision.dart';

const EdgeVisionSettings initialSettings = EdgeVisionSettings(
  searchMatrixSize: 3,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 0.1,
  skewnessThreshold: 0.15,
  blackWhiteThreshold: 130,
  sobelLevel: 0.2,
  sobelAmount: 1,
  blurRadius: 3,
  areaThreshold: 0.35,
  luminanceThreshold: 1.20,
  grayscaleLevel: 0.2,
  grayscaleAmount: 1,
  maxImageSize: 1000, // Do not resize during the tests
);

const EdgeVisionSettings targetSettings = EdgeVisionSettings.zero(
  sobelLevel: 2,
  grayscaleLevel: 7,
  grayscaleAmount: 3,
  // searchMatrixSize: 4,
  // blackWhiteThreshold: 180,
  // sobelAmount: 2,
  // blurRadius: 5,
  // luminanceThreshold: 1.20,
);

const EdgeVisionSettings stepSettings = EdgeVisionSettings.zero(
  sobelLevel: 0.15,
  sobelAmount: 2,
  // grayscaleLevel: 0.2,
  // grayscaleAmount: 1,
  // searchMatrixSize: 1,
  // blackWhiteThreshold: 10,
  // blurRadius: 1,
  // luminanceThreshold: 0.05,
);
