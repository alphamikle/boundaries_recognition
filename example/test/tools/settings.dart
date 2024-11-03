import 'package:edge_vision/edge_vision.dart';

const Settings initialSettings = Settings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  distortionAngleThreshold: 3,
  skewnessThreshold: 0.1,
  blackWhiteThreshold: 125,
  grayscaleAmount: 0.5,
  sobelAmount: 0.5,
  blurRadius: 2,
);

const Settings endSettings = Settings(
  searchMatrixSize: 4,
  minObjectSize: 60,
  distortionAngleThreshold: 5,
  skewnessThreshold: 0.3,
  blackWhiteThreshold: 175,
  grayscaleAmount: 7,
  sobelAmount: 2,
  blurRadius: 4,
);

const Settings stepSettings = Settings(
  searchMatrixSize: 2,
  minObjectSize: 20,
  distortionAngleThreshold: 0.5,
  skewnessThreshold: 0.1,
  blackWhiteThreshold: 25,
  grayscaleAmount: 0.5,
  sobelAmount: 0.5,
  blurRadius: 1,
);
