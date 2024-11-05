class EdgeVisionSettings {
  const EdgeVisionSettings({
    required this.searchMatrixSize,
    required this.minObjectSize,
    required this.directionAngleLevel,
    required this.symmetricAngleThreshold,
    required this.skewnessThreshold,
    required this.blackWhiteThreshold,
    required this.grayscaleLevel,
    required this.grayscaleAmount,
    required this.sobelLevel,
    required this.sobelAmount,
    required this.blurRadius,
    required this.areaThreshold,
    required this.luminanceThreshold,
  });

  const EdgeVisionSettings.zero({
    this.searchMatrixSize = 0,
    this.minObjectSize = 0,
    this.directionAngleLevel = 0,
    this.symmetricAngleThreshold = 0,
    this.skewnessThreshold = 0,
    this.blackWhiteThreshold = 0,
    this.grayscaleLevel = 0,
    this.grayscaleAmount = 0,
    this.sobelLevel = 0,
    this.sobelAmount = 0,
    this.blurRadius = 0,
    this.areaThreshold = 0,
    this.luminanceThreshold = 0,
  });

  factory EdgeVisionSettings.fromFields(List<num> fields) {
    return EdgeVisionSettings(
      searchMatrixSize: fields[0].toInt(),
      minObjectSize: fields[1].toInt(),
      directionAngleLevel: fields[2].toDouble(),
      symmetricAngleThreshold: fields[3].toDouble(),
      skewnessThreshold: fields[4].toDouble(),
      blackWhiteThreshold: fields[5].toInt(),
      grayscaleLevel: fields[6].toDouble(),
      grayscaleAmount: fields[7].toInt(),
      sobelLevel: fields[8].toDouble(),
      sobelAmount: fields[9].toInt(),
      blurRadius: fields[10].toInt(),
      areaThreshold: fields[11].toDouble(),
      luminanceThreshold: fields[12].toDouble(),
    );
  }

  /// Search matrix size - neighboring pixels to be searched relative to the current pixel
  final int searchMatrixSize;

  /// Minimum size (in pixels) for the object to be considered in the results
  final int minObjectSize;

  final double directionAngleLevel;

  final double symmetricAngleThreshold;

  final double skewnessThreshold;

  final int blackWhiteThreshold;

  final double grayscaleLevel;

  final int grayscaleAmount;

  final double sobelLevel;

  final int sobelAmount;

  final int blurRadius;

  final double areaThreshold;

  final double luminanceThreshold;

  List<num> get fields => [
        searchMatrixSize,
        minObjectSize,
        directionAngleLevel,
        symmetricAngleThreshold,
        skewnessThreshold,
        blackWhiteThreshold,
        grayscaleLevel,
        grayscaleAmount,
        sobelLevel,
        sobelAmount,
        blurRadius,
        areaThreshold,
        luminanceThreshold,
      ];

  EdgeVisionSettings operator +(EdgeVisionSettings other) => EdgeVisionSettings(
        searchMatrixSize: searchMatrixSize + other.searchMatrixSize,
        minObjectSize: minObjectSize + other.minObjectSize,
        directionAngleLevel: directionAngleLevel + other.directionAngleLevel,
        symmetricAngleThreshold: symmetricAngleThreshold + other.symmetricAngleThreshold,
        skewnessThreshold: skewnessThreshold + other.skewnessThreshold,
        blackWhiteThreshold: blackWhiteThreshold + other.blackWhiteThreshold,
        grayscaleLevel: grayscaleLevel + other.grayscaleLevel,
        grayscaleAmount: grayscaleAmount + other.grayscaleAmount,
        sobelLevel: sobelLevel + other.sobelLevel,
        sobelAmount: sobelAmount + other.sobelAmount,
        blurRadius: blurRadius + other.blurRadius,
        areaThreshold: areaThreshold + other.areaThreshold,
        luminanceThreshold: luminanceThreshold + other.luminanceThreshold,
      );

  EdgeVisionSettings operator /(num delimiter) => EdgeVisionSettings(
        searchMatrixSize: searchMatrixSize ~/ delimiter,
        minObjectSize: minObjectSize ~/ delimiter,
        directionAngleLevel: directionAngleLevel / delimiter,
        symmetricAngleThreshold: symmetricAngleThreshold / delimiter,
        skewnessThreshold: skewnessThreshold / delimiter,
        blackWhiteThreshold: blackWhiteThreshold ~/ delimiter,
        grayscaleLevel: grayscaleLevel / delimiter,
        grayscaleAmount: grayscaleAmount ~/ delimiter,
        sobelLevel: sobelLevel / delimiter,
        sobelAmount: sobelAmount ~/ delimiter,
        blurRadius: blurRadius ~/ delimiter,
        areaThreshold: areaThreshold / delimiter,
        luminanceThreshold: luminanceThreshold / luminanceThreshold,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EdgeVisionSettings &&
          runtimeType == other.runtimeType &&
          searchMatrixSize == other.searchMatrixSize &&
          minObjectSize == other.minObjectSize &&
          directionAngleLevel == other.directionAngleLevel &&
          symmetricAngleThreshold == other.symmetricAngleThreshold &&
          skewnessThreshold == other.skewnessThreshold &&
          blackWhiteThreshold == other.blackWhiteThreshold &&
          grayscaleLevel == other.grayscaleLevel &&
          grayscaleAmount == other.grayscaleAmount &&
          sobelLevel == other.sobelLevel &&
          sobelAmount == other.sobelAmount &&
          blurRadius == other.blurRadius &&
          areaThreshold == other.areaThreshold &&
          luminanceThreshold == other.luminanceThreshold;

  @override
  int get hashCode =>
      searchMatrixSize.hashCode ^
      minObjectSize.hashCode ^
      directionAngleLevel.hashCode ^
      symmetricAngleThreshold.hashCode ^
      skewnessThreshold.hashCode ^
      blackWhiteThreshold.hashCode ^
      grayscaleLevel.hashCode ^
      grayscaleAmount.hashCode ^
      sobelLevel.hashCode ^
      sobelAmount.hashCode ^
      blurRadius.hashCode ^
      areaThreshold.hashCode ^
      luminanceThreshold.hashCode;

  @override
  String toString() {
    return '''
EdgeVisionSettings{
  searchMatrixSize: $searchMatrixSize,
  minObjectSize: $minObjectSize,
  directionAngleLevel: $directionAngleLevel,
  symmetricAngleThreshold: $symmetricAngleThreshold,
  skewnessThreshold: $skewnessThreshold,
  blackWhiteThreshold: $blackWhiteThreshold,
  grayscaleLevel: $grayscaleLevel,
  grayscaleAmount: $grayscaleAmount,
  sobelLevel: $sobelLevel,
  sobelAmount: $sobelAmount,
  blurRadius: $blurRadius,
  areaThreshold: $areaThreshold,
  luminanceThreshold: $luminanceThreshold,
}''';
  }

  EdgeVisionSettings copyWith({
    int? searchMatrixSize,
    int? minObjectSize,
    double? directionAngleLevel,
    double? symmetricAngleThreshold,
    double? skewnessThreshold,
    int? blackWhiteThreshold,
    double? grayscaleLevel,
    int? grayscaleAmount,
    double? sobelLevel,
    int? sobelAmount,
    int? blurRadius,
    double? areaThreshold,
    double? luminanceThreshold,
  }) {
    return EdgeVisionSettings(
      searchMatrixSize: searchMatrixSize ?? this.searchMatrixSize,
      minObjectSize: minObjectSize ?? this.minObjectSize,
      directionAngleLevel: directionAngleLevel ?? this.directionAngleLevel,
      symmetricAngleThreshold: symmetricAngleThreshold ?? this.symmetricAngleThreshold,
      skewnessThreshold: skewnessThreshold ?? this.skewnessThreshold,
      blackWhiteThreshold: blackWhiteThreshold ?? this.blackWhiteThreshold,
      grayscaleLevel: grayscaleLevel ?? this.grayscaleLevel,
      grayscaleAmount: grayscaleAmount ?? this.grayscaleAmount,
      sobelLevel: sobelLevel ?? this.sobelLevel,
      sobelAmount: sobelAmount ?? this.sobelAmount,
      blurRadius: blurRadius ?? this.blurRadius,
      areaThreshold: areaThreshold ?? this.areaThreshold,
      luminanceThreshold: luminanceThreshold ?? this.luminanceThreshold,
    );
  }
}
