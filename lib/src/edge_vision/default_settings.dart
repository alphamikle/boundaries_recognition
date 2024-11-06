import '../tools/settings_extension.dart';
import 'edge_vision_settings.dart';

const int searchMatrixSize = 2;
const int minObjectSize = 40;
const double directionAngleLevel = 3;
const double symmetricAngleThreshold = 6;
const double skewnessThreshold = 0.125;
const double areaThreshold = 0.35;
const double luminanceThreshold = 1.25;

/// [Check with config: dark or black and light or white] Best result: 3 / 3 or 100.00%
const EdgeVisionSettings darkOnLightSettings = EdgeVisionSettings(
  searchMatrixSize: searchMatrixSize,
  minObjectSize: minObjectSize,
  directionAngleLevel: directionAngleLevel,
  symmetricAngleThreshold: symmetricAngleThreshold,
  skewnessThreshold: skewnessThreshold,
  areaThreshold: areaThreshold,
  luminanceThreshold: luminanceThreshold,
  blackWhiteThreshold: 125,
  sobelLevel: 1,
  sobelAmount: 1,
  blurRadius: 3,
  maxImageSize: 300,
);

/// [Check with config: light or white and dark or black] Best result: 15 / 20 or 75.00%
const EdgeVisionSettings lightOnDarkSettings = EdgeVisionSettings(
  searchMatrixSize: searchMatrixSize,
  minObjectSize: minObjectSize,
  directionAngleLevel: directionAngleLevel,
  symmetricAngleThreshold: symmetricAngleThreshold,
  skewnessThreshold: skewnessThreshold,
  areaThreshold: areaThreshold,
  luminanceThreshold: luminanceThreshold,
  blackWhiteThreshold: 125,
  sobelLevel: 1,
  sobelAmount: 1,
  blurRadius: 3,
  maxImageSize: 300,
);

/// [Check with config: dark or black and color] Best result: 0 / 0 or NaN%
final EdgeVisionSettings darkOnColorSettings = throw UnimplementedError('Need to extend dataset and do more tests');

/// [Check with config: light or white and light or white] Best result: 10 / 14 or 71.43%
const EdgeVisionSettings lightOnLightSettings = EdgeVisionSettings(
  searchMatrixSize: searchMatrixSize,
  minObjectSize: minObjectSize,
  directionAngleLevel: directionAngleLevel,
  symmetricAngleThreshold: symmetricAngleThreshold,
  skewnessThreshold: skewnessThreshold,
  areaThreshold: areaThreshold,
  luminanceThreshold: luminanceThreshold,
  blackWhiteThreshold: 125,
  sobelLevel: 0.5,
  sobelAmount: 1,
  blurRadius: 2,
  maxImageSize: 300,
);

/// [Check with config: color and color] Best result: 4 / 5 or 80.00%
const EdgeVisionSettings colorOnColorSettings = EdgeVisionSettings(
  searchMatrixSize: searchMatrixSize,
  minObjectSize: minObjectSize,
  directionAngleLevel: directionAngleLevel,
  symmetricAngleThreshold: symmetricAngleThreshold,
  skewnessThreshold: skewnessThreshold,
  areaThreshold: areaThreshold,
  luminanceThreshold: luminanceThreshold,
  blackWhiteThreshold: 125,
  sobelLevel: 0.5,
  sobelAmount: 1,
  blurRadius: 2,
  maxImageSize: 300,
);

/// [Check with config: color and dark or black] Best result: 33 / 51 or 64.71%
const EdgeVisionSettings colorOnDarkSettings = EdgeVisionSettings(
  searchMatrixSize: searchMatrixSize,
  minObjectSize: minObjectSize,
  directionAngleLevel: directionAngleLevel,
  symmetricAngleThreshold: symmetricAngleThreshold,
  skewnessThreshold: skewnessThreshold,
  areaThreshold: areaThreshold,
  luminanceThreshold: luminanceThreshold,
  blackWhiteThreshold: 125,
  sobelLevel: 0.5,
  sobelAmount: 1,
  blurRadius: 2,
  maxImageSize: 300,
);

/// [Check with config: color and light or white] Best result: 19 / 26 or 73.08%
const EdgeVisionSettings colorOnLightSettings = EdgeVisionSettings(
  searchMatrixSize: searchMatrixSize,
  minObjectSize: minObjectSize,
  directionAngleLevel: directionAngleLevel,
  symmetricAngleThreshold: symmetricAngleThreshold,
  skewnessThreshold: skewnessThreshold,
  areaThreshold: areaThreshold,
  luminanceThreshold: luminanceThreshold,
  blackWhiteThreshold: 125,
  sobelLevel: 1.5,
  sobelAmount: 1,
  blurRadius: 2,
  maxImageSize: 300,
);

/// [Check with config: dark or black and dark or black] Best result: 6 / 7 or 85.71%
const EdgeVisionSettings darkOnDarkSettings = EdgeVisionSettings(
  searchMatrixSize: searchMatrixSize,
  minObjectSize: minObjectSize,
  directionAngleLevel: directionAngleLevel,
  symmetricAngleThreshold: symmetricAngleThreshold,
  skewnessThreshold: skewnessThreshold,
  areaThreshold: areaThreshold,
  luminanceThreshold: luminanceThreshold,
  blackWhiteThreshold: 125,
  sobelLevel: 0.5,
  sobelAmount: 1,
  blurRadius: 2,
  maxImageSize: 300,
);

/// [Check with config: light or white and color] Best result: 3 / 4 or 75.00%
const EdgeVisionSettings lightOnColorSettings = EdgeVisionSettings(
  searchMatrixSize: searchMatrixSize,
  minObjectSize: minObjectSize,
  directionAngleLevel: directionAngleLevel,
  symmetricAngleThreshold: symmetricAngleThreshold,
  skewnessThreshold: skewnessThreshold,
  areaThreshold: areaThreshold,
  luminanceThreshold: luminanceThreshold,
  blackWhiteThreshold: 125,
  sobelLevel: 0.5,
  sobelAmount: 1,
  blurRadius: 2,
  maxImageSize: 300,
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
  lightOnLightSettings,
  colorOnLightSettings,
};

final EdgeVisionSettings averageSettings = _allSettings.average();
