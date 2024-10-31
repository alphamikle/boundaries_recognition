class Settings {
  const Settings({
    this.searchMatrixSize = 3,
    this.minObjectSize = 40,
    this.distortionAngleThreshold = 5,
    this.skewnessThreshold = 0.25,
    this.blackWhiteThreshold = 160,
    this.grayscaleAmount = 1.20,
    this.sobelAmount = 1.20,
    this.blurRadius = 2,
  });

  const Settings.light({
    this.searchMatrixSize = 3,
    this.minObjectSize = 40,
    this.distortionAngleThreshold = 5,
    this.skewnessThreshold = 0.25,
    this.blackWhiteThreshold = 160,
    this.grayscaleAmount = 6.25,
    this.sobelAmount = 1.20,
    this.blurRadius = 2,
  });

  const Settings.dark({
    this.searchMatrixSize = 3,
    this.minObjectSize = 40,
    this.distortionAngleThreshold = 5,
    this.skewnessThreshold = 0.25,
    this.blackWhiteThreshold = 160,
    this.grayscaleAmount = 1.20,
    this.sobelAmount = 1.20,
    this.blurRadius = 2,
  });

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
