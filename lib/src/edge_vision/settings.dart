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
  });

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
          areaThreshold == other.areaThreshold;

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
      areaThreshold.hashCode;

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
    );
  }
}
