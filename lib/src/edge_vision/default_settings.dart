import '../tools/settings_extension.dart';
import 'settings.dart';

/// [Check with config: dark or black and light or white] Best result: 3 / 3 or 100.00%
const Settings darkOnLightSettings = Settings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  distortionAngleThreshold: 3,
  skewnessThreshold: 0.1,
  blackWhiteThreshold: 125,
  grayscaleAmount: 0.5,
  sobelAmount: 1,
  blurRadius: 3,
);

/// [Check with config: light or white and dark or black] Best result: 15 / 20 or 75.00%
const Settings lightOnDarkSettings = Settings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  distortionAngleThreshold: 3,
  skewnessThreshold: 0.1,
  blackWhiteThreshold: 125,
  grayscaleAmount: 0.5,
  sobelAmount: 1,
  blurRadius: 3,
);

/// [Check with config: dark or black and color] Best result: 0 / 0 or NaN%
final Settings darkOnColorSettings = throw UnimplementedError('Need to extend dataset and do more tests');

/// [Check with config: light or white and light or white] Best result: 10 / 14 or 71.43%
const Settings lightOnLightSettings = Settings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  distortionAngleThreshold: 3,
  skewnessThreshold: 0.2,
  blackWhiteThreshold: 125,
  grayscaleAmount: 5,
  sobelAmount: 0.5,
  blurRadius: 2,
);

/// [Check with config: color and color] Best result: 4 / 5 or 80.00%
const Settings colorOnColorSettings = Settings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  distortionAngleThreshold: 3,
  skewnessThreshold: 0.2,
  blackWhiteThreshold: 125,
  grayscaleAmount: 2,
  sobelAmount: 0.5,
  blurRadius: 2,
);

/// [Check with config: color and dark or black] Best result: 33 / 51 or 64.71%
const Settings colorOnDarkSettings = Settings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  distortionAngleThreshold: 3,
  skewnessThreshold: 0.1,
  blackWhiteThreshold: 125,
  grayscaleAmount: 1,
  sobelAmount: 0.5,
  blurRadius: 2,
);

/// [Check with config: color and light or white] Best result: 19 / 26 or 73.08%
const Settings colorOnLightSettings = Settings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  distortionAngleThreshold: 3,
  skewnessThreshold: 0.1,
  blackWhiteThreshold: 125,
  grayscaleAmount: 1,
  sobelAmount: 1.5,
  blurRadius: 2,
);

/// [Check with config: dark or black and dark or black] Best result: 6 / 7 or 85.71%
const Settings darkOnDarkSettings = Settings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  distortionAngleThreshold: 3,
  skewnessThreshold: 0.2,
  blackWhiteThreshold: 125,
  grayscaleAmount: 2,
  sobelAmount: 0.5,
  blurRadius: 2,
);

/// [Check with config: light or white and color] Best result: 3 / 4 or 75.00%
const Settings lightOnColorSettings = Settings(
  searchMatrixSize: 2,
  minObjectSize: 40,
  distortionAngleThreshold: 3,
  skewnessThreshold: 0.2,
  blackWhiteThreshold: 125,
  grayscaleAmount: 3,
  sobelAmount: 0.5,
  blurRadius: 2,
);

final List<Settings> _allSettings = [
  darkOnLightSettings,
  lightOnDarkSettings,
  lightOnLightSettings,
  colorOnColorSettings,
  colorOnDarkSettings,
  colorOnLightSettings,
  darkOnDarkSettings,
  lightOnColorSettings,
];

final Set<Settings> defaultSettings = {
  darkOnLightSettings,
  lightOnDarkSettings,
  lightOnLightSettings,
  colorOnColorSettings,
  colorOnDarkSettings,
  colorOnLightSettings,
  darkOnDarkSettings,
  lightOnColorSettings,
};

final Settings averageSettings = _allSettings.average();
