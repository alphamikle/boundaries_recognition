import '../tools/settings_extension.dart';
import 'edge_vision_settings.dart';

const int searchMatrixSize = 3;
const int minObjectSize = 40;
const double directionAngleLevel = 3;
const double symmetricAngleThreshold = 0.15;
const double skewnessThreshold = 0.15;
const double areaThreshold = 0.25;
const double luminanceThreshold = 1.15;

/// [Check with config: dark or black and light or white] Best result: 3 / 3 or 100.00%
const EdgeVisionSettings darkOnLightSettings = EdgeVisionSettings(
  searchMatrixSize: searchMatrixSize,
  minObjectSize: minObjectSize,
  directionAngleLevel: directionAngleLevel,
  symmetricAngleThreshold: symmetricAngleThreshold,
  skewnessThreshold: skewnessThreshold,
  areaThreshold: areaThreshold,
  luminanceThreshold: luminanceThreshold,
  blackWhiteThreshold: 129,
  sobelLevel: 1.10,
  sobelAmount: 1,
  blurRadius: 3,
  maxImageSize: 300,
  grayscaleAmount: 0,
  grayscaleLevel: 0,
);

final List<EdgeVisionSettings> _allSettings = [
  darkOnLightSettings,
];

final Set<EdgeVisionSettings> defaultSettings = {
  darkOnLightSettings,
};

final EdgeVisionSettings averageSettings = _allSettings.average();
