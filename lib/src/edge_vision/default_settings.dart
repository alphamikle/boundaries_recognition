import '../tools/settings_extension.dart';
import 'settings.dart';

/// [Check with config: dark or black and light or white] Best result: 3 / 3 or 100.00%
const EdgeVisionSettings darkOnLightSettings = EdgeVisionSettings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 6,
  skewnessThreshold: 0.1,
  blackWhiteThreshold: 125,
  grayscaleLevel: 0.5,
  grayscaleAmount: 1,
  sobelLevel: 1,
  sobelAmount: 1,
  blurRadius: 3,
  areaThreshold: 0.65,
);

/// [Check with config: light or white and dark or black] Best result: 15 / 20 or 75.00%
const EdgeVisionSettings lightOnDarkSettings = EdgeVisionSettings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 6,
  skewnessThreshold: 0.1,
  blackWhiteThreshold: 125,
  grayscaleLevel: 0.5,
  grayscaleAmount: 1,
  sobelLevel: 1,
  sobelAmount: 1,
  blurRadius: 3,
  areaThreshold: 0.65,
);

/// [Check with config: dark or black and color] Best result: 0 / 0 or NaN%
final EdgeVisionSettings darkOnColorSettings = throw UnimplementedError('Need to extend dataset and do more tests');

/// [Check with config: light or white and light or white] Best result: 10 / 14 or 71.43%
const EdgeVisionSettings lightOnLightSettings = EdgeVisionSettings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 6,
  skewnessThreshold: 0.2,
  blackWhiteThreshold: 125,
  grayscaleLevel: 5,
  grayscaleAmount: 1,
  sobelLevel: 0.5,
  sobelAmount: 1,
  blurRadius: 2,
  areaThreshold: 0.65,
);

/// [Check with config: color and color] Best result: 4 / 5 or 80.00%
const EdgeVisionSettings colorOnColorSettings = EdgeVisionSettings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 6,
  skewnessThreshold: 0.2,
  blackWhiteThreshold: 125,
  grayscaleLevel: 2,
  grayscaleAmount: 1,
  sobelLevel: 0.5,
  sobelAmount: 1,
  blurRadius: 2,
  areaThreshold: 0.65,
);

/// [Check with config: color and dark or black] Best result: 33 / 51 or 64.71%
const EdgeVisionSettings colorOnDarkSettings = EdgeVisionSettings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 6,
  skewnessThreshold: 0.1,
  blackWhiteThreshold: 125,
  grayscaleLevel: 1,
  grayscaleAmount: 1,
  sobelLevel: 0.5,
  sobelAmount: 1,
  blurRadius: 2,
  areaThreshold: 0.65,
);

/// [Check with config: color and light or white] Best result: 19 / 26 or 73.08%
const EdgeVisionSettings colorOnLightSettings = EdgeVisionSettings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 6,
  skewnessThreshold: 0.1,
  blackWhiteThreshold: 125,
  grayscaleLevel: 1,
  grayscaleAmount: 1,
  sobelLevel: 1.5,
  sobelAmount: 1,
  blurRadius: 2,
  areaThreshold: 0.65,
);

/// [Check with config: dark or black and dark or black] Best result: 6 / 7 or 85.71%
const EdgeVisionSettings darkOnDarkSettings = EdgeVisionSettings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 6,
  skewnessThreshold: 0.2,
  blackWhiteThreshold: 125,
  grayscaleLevel: 2,
  grayscaleAmount: 1,
  sobelLevel: 0.5,
  sobelAmount: 1,
  blurRadius: 2,
  areaThreshold: 0.65,
);

/// [Check with config: light or white and color] Best result: 3 / 4 or 75.00%
const EdgeVisionSettings lightOnColorSettings = EdgeVisionSettings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  directionAngleLevel: 3,
  symmetricAngleThreshold: 6,
  skewnessThreshold: 0.2,
  blackWhiteThreshold: 125,
  grayscaleLevel: 3,
  grayscaleAmount: 1,
  sobelLevel: 0.5,
  sobelAmount: 1,
  blurRadius: 2,
  areaThreshold: 0.65,
);

final List<EdgeVisionSettings> _allSettings = [
  darkOnLightSettings,
  lightOnDarkSettings,
  lightOnLightSettings,
  colorOnColorSettings,
  colorOnDarkSettings,
  colorOnLightSettings,
  darkOnDarkSettings,
  lightOnColorSettings,
];

final Set<EdgeVisionSettings> defaultSettings = {
  darkOnLightSettings,
  lightOnDarkSettings,
  lightOnLightSettings,
  colorOnColorSettings,
  colorOnDarkSettings,
  colorOnLightSettings,
  darkOnDarkSettings,
  lightOnColorSettings,
};

final EdgeVisionSettings averageSettings = _allSettings.average();
