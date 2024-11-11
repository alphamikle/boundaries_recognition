import 'package:edge_vision/edge_vision.dart';

extension ExtendedEdgeSettings on EdgeVisionSettings {
  String toCode(String name, {bool withImport = true}) {
    return '''
${withImport ? ["import 'package:edge_vision/edge_vision.dart';", '\n'].join() : ''}
const EdgeVisionSettings $name = EdgeVisionSettings(
  searchMatrixSize: $searchMatrixSize,
  minObjectSize: $minObjectSize,
  directionAngleLevel: $directionAngleLevel,
  symmetricAngleThreshold: $symmetricAngleThreshold,
  skewnessThreshold: $skewnessThreshold,
  blackWhiteThreshold: $blackWhiteThreshold,
  sobelLevel: $sobelLevel,
  sobelAmount: $sobelAmount,
  blurRadius: $blurRadius,
  areaThreshold: $areaThreshold,
  luminanceThreshold: $luminanceThreshold,
  maxImageSize: $maxImageSize,
  grayscaleLevel: $grayscaleLevel,
  grayscaleAmount: $grayscaleAmount,
);
''';
  }
}
