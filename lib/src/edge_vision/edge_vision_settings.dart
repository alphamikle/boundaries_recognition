class EdgeVisionSettings {
  const EdgeVisionSettings({
    required this.searchMatrixSize,
    required this.minObjectSize,
    required this.directionAngleLevel,
    required this.symmetricAngleThreshold,
    required this.skewnessThreshold,
    required this.blackWhiteThreshold,
    required this.sobelLevel,
    required this.sobelAmount,
    required this.blurRadius,
    required this.areaThreshold,
    required this.luminanceThreshold,
    required this.maxImageSize,
    this.returnInvalidData = false,
  });

  const EdgeVisionSettings.zero({
    this.searchMatrixSize = 0,
    this.minObjectSize = 0,
    this.directionAngleLevel = 0,
    this.symmetricAngleThreshold = 0,
    this.skewnessThreshold = 0,
    this.blackWhiteThreshold = 0,
    this.sobelLevel = 0,
    this.sobelAmount = 0,
    this.blurRadius = 0,
    this.areaThreshold = 0,
    this.luminanceThreshold = 0,
    this.maxImageSize = 0,
    this.returnInvalidData = false,
  });

  factory EdgeVisionSettings.fromFields(List<num> fields) {
    return EdgeVisionSettings(
      searchMatrixSize: fields[0].toInt(),
      minObjectSize: fields[1].toInt(),
      directionAngleLevel: fields[2].toDouble(),
      symmetricAngleThreshold: fields[3].toDouble(),
      skewnessThreshold: fields[4].toDouble(),
      blackWhiteThreshold: fields[5].toInt(),
      sobelLevel: fields[6].toDouble(),
      sobelAmount: fields[7].toInt(),
      blurRadius: fields[8].toInt(),
      areaThreshold: fields[9].toDouble(),
      luminanceThreshold: fields[10].toDouble(),
      maxImageSize: fields[11].toInt(),
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

  final double sobelLevel;

  final int sobelAmount;

  final int blurRadius;

  final double areaThreshold;

  final double luminanceThreshold;

  final int maxImageSize;

  final bool returnInvalidData;

  List<num> get fields => [
        searchMatrixSize, // 0
        minObjectSize, // 1
        directionAngleLevel, // 2
        symmetricAngleThreshold, // 3
        skewnessThreshold, // 4
        blackWhiteThreshold, // 5
        sobelLevel, // 6
        sobelAmount, // 7
        blurRadius, // 8
        areaThreshold, // 9
        luminanceThreshold, // 10
        maxImageSize, // 11
      ];

  EdgeVisionSettings operator +(EdgeVisionSettings other) => EdgeVisionSettings(
        searchMatrixSize: searchMatrixSize + other.searchMatrixSize,
        minObjectSize: minObjectSize + other.minObjectSize,
        directionAngleLevel: directionAngleLevel + other.directionAngleLevel,
        symmetricAngleThreshold: symmetricAngleThreshold + other.symmetricAngleThreshold,
        skewnessThreshold: skewnessThreshold + other.skewnessThreshold,
        blackWhiteThreshold: blackWhiteThreshold + other.blackWhiteThreshold,
        sobelLevel: sobelLevel + other.sobelLevel,
        sobelAmount: sobelAmount + other.sobelAmount,
        blurRadius: blurRadius + other.blurRadius,
        areaThreshold: areaThreshold + other.areaThreshold,
        luminanceThreshold: luminanceThreshold + other.luminanceThreshold,
        maxImageSize: maxImageSize + other.maxImageSize,
      );

  EdgeVisionSettings operator /(num delimiter) => EdgeVisionSettings(
        searchMatrixSize: searchMatrixSize ~/ delimiter,
        minObjectSize: minObjectSize ~/ delimiter,
        directionAngleLevel: directionAngleLevel / delimiter,
        symmetricAngleThreshold: symmetricAngleThreshold / delimiter,
        skewnessThreshold: skewnessThreshold / delimiter,
        blackWhiteThreshold: blackWhiteThreshold ~/ delimiter,
        sobelLevel: sobelLevel / delimiter,
        sobelAmount: sobelAmount ~/ delimiter,
        blurRadius: blurRadius ~/ delimiter,
        areaThreshold: areaThreshold / delimiter,
        luminanceThreshold: luminanceThreshold / luminanceThreshold,
        maxImageSize: maxImageSize ~/ delimiter,
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
          sobelLevel == other.sobelLevel &&
          sobelAmount == other.sobelAmount &&
          blurRadius == other.blurRadius &&
          areaThreshold == other.areaThreshold &&
          luminanceThreshold == other.luminanceThreshold &&
          maxImageSize == other.maxImageSize;

  @override
  int get hashCode =>
      searchMatrixSize.hashCode ^
      minObjectSize.hashCode ^
      directionAngleLevel.hashCode ^
      symmetricAngleThreshold.hashCode ^
      skewnessThreshold.hashCode ^
      blackWhiteThreshold.hashCode ^
      sobelLevel.hashCode ^
      sobelAmount.hashCode ^
      blurRadius.hashCode ^
      areaThreshold.hashCode ^
      luminanceThreshold.hashCode ^
      maxImageSize.hashCode;

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
  sobelLevel: $sobelLevel,
  sobelAmount: $sobelAmount,
  blurRadius: $blurRadius,
  areaThreshold: $areaThreshold,
  luminanceThreshold: $luminanceThreshold,
  maxImageSize: $maxImageSize,
  returnInvalidData: $returnInvalidData,
}''';
  }

  EdgeVisionSettings copyWith({
    int? searchMatrixSize,
    int? minObjectSize,
    double? directionAngleLevel,
    double? symmetricAngleThreshold,
    double? skewnessThreshold,
    int? blackWhiteThreshold,
    double? sobelLevel,
    int? sobelAmount,
    int? blurRadius,
    double? areaThreshold,
    double? luminanceThreshold,
    int? maxImageSize,
    bool? returnInvalidData,
  }) {
    return EdgeVisionSettings(
      searchMatrixSize: searchMatrixSize ?? this.searchMatrixSize,
      minObjectSize: minObjectSize ?? this.minObjectSize,
      directionAngleLevel: directionAngleLevel ?? this.directionAngleLevel,
      symmetricAngleThreshold: symmetricAngleThreshold ?? this.symmetricAngleThreshold,
      skewnessThreshold: skewnessThreshold ?? this.skewnessThreshold,
      blackWhiteThreshold: blackWhiteThreshold ?? this.blackWhiteThreshold,
      sobelLevel: sobelLevel ?? this.sobelLevel,
      sobelAmount: sobelAmount ?? this.sobelAmount,
      blurRadius: blurRadius ?? this.blurRadius,
      areaThreshold: areaThreshold ?? this.areaThreshold,
      luminanceThreshold: luminanceThreshold ?? this.luminanceThreshold,
      maxImageSize: maxImageSize ?? this.maxImageSize,
      returnInvalidData: returnInvalidData ?? this.returnInvalidData,
    );
  }
}
