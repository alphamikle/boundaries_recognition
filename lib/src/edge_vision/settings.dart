class Settings {
  const Settings({
    required this.searchMatrixSize,
    required this.minObjectSize,
    required this.distortionAngleThreshold,
    required this.skewnessThreshold,
    required this.blackWhiteThreshold,
    required this.grayscaleAmount,
    required this.sobelAmount,
    required this.blurRadius,
  });

  const Settings.zero()
      : searchMatrixSize = 0,
        minObjectSize = 0,
        distortionAngleThreshold = 0,
        skewnessThreshold = 0,
        blackWhiteThreshold = 0,
        grayscaleAmount = 0,
        sobelAmount = 0,
        blurRadius = 0;

  /// Search matrix size - neighboring pixels to be searched relative to the current pixel
  final int searchMatrixSize;

  /// Minimum size (in pixels) for the object to be considered in the results
  final int minObjectSize;

  final double distortionAngleThreshold;

  final double skewnessThreshold;

  final int blackWhiteThreshold;

  final double grayscaleAmount;

  final double sobelAmount;

  final int blurRadius;

  Settings operator +(Settings other) => Settings(
        searchMatrixSize: searchMatrixSize + other.searchMatrixSize,
        minObjectSize: minObjectSize + other.minObjectSize,
        distortionAngleThreshold: distortionAngleThreshold + other.distortionAngleThreshold,
        skewnessThreshold: skewnessThreshold + other.skewnessThreshold,
        blackWhiteThreshold: blackWhiteThreshold + other.blackWhiteThreshold,
        grayscaleAmount: grayscaleAmount + other.grayscaleAmount,
        sobelAmount: sobelAmount + other.sobelAmount,
        blurRadius: blurRadius + other.blurRadius,
      );

  Settings operator /(num delimiter) => Settings(
        searchMatrixSize: searchMatrixSize ~/ delimiter,
        minObjectSize: minObjectSize ~/ delimiter,
        distortionAngleThreshold: distortionAngleThreshold / delimiter,
        skewnessThreshold: skewnessThreshold / delimiter,
        blackWhiteThreshold: blackWhiteThreshold ~/ delimiter,
        grayscaleAmount: grayscaleAmount / delimiter,
        sobelAmount: sobelAmount / delimiter,
        blurRadius: blurRadius ~/ delimiter,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Settings &&
          runtimeType == other.runtimeType &&
          searchMatrixSize == other.searchMatrixSize &&
          minObjectSize == other.minObjectSize &&
          distortionAngleThreshold == other.distortionAngleThreshold &&
          skewnessThreshold == other.skewnessThreshold &&
          blackWhiteThreshold == other.blackWhiteThreshold &&
          grayscaleAmount == other.grayscaleAmount &&
          sobelAmount == other.sobelAmount &&
          blurRadius == other.blurRadius;

  @override
  int get hashCode =>
      searchMatrixSize.hashCode ^
      minObjectSize.hashCode ^
      distortionAngleThreshold.hashCode ^
      skewnessThreshold.hashCode ^
      blackWhiteThreshold.hashCode ^
      grayscaleAmount.hashCode ^
      sobelAmount.hashCode ^
      blurRadius.hashCode;

  Settings copyWith({
    int? searchMatrixSize,
    int? minObjectSize,
    double? distortionAngleThreshold,
    double? skewnessThreshold,
    int? blackWhiteThreshold,
    double? grayscaleAmount,
    double? sobelAmount,
    int? blurRadius,
  }) {
    return Settings(
      searchMatrixSize: searchMatrixSize ?? this.searchMatrixSize,
      minObjectSize: minObjectSize ?? this.minObjectSize,
      distortionAngleThreshold: distortionAngleThreshold ?? this.distortionAngleThreshold,
      skewnessThreshold: skewnessThreshold ?? this.skewnessThreshold,
      blackWhiteThreshold: blackWhiteThreshold ?? this.blackWhiteThreshold,
      grayscaleAmount: grayscaleAmount ?? this.grayscaleAmount,
      sobelAmount: sobelAmount ?? this.sobelAmount,
      blurRadius: blurRadius ?? this.blurRadius,
    );
  }

  @override
  String toString() {
    return '''
Settings {
  searchMatrixSize: $searchMatrixSize
  minObjectSize: $minObjectSize
  distortionAngleThreshold: $distortionAngleThreshold
  skewnessThreshold: $skewnessThreshold
  blackWhiteThreshold: $blackWhiteThreshold
  grayscaleAmount: $grayscaleAmount
  sobelAmount: $sobelAmount
  blurRadius: $blurRadius
}''';
  }
}
