class Settings {
  const Settings({
    required this.grayscale,
    required this.sobel,
    required this.colorThreshold,
    required this.searchThreshold,
    required this.groupSize,
    required this.angle,
    required this.proportionThreshold,
  });

  final FilterSettings grayscale;
  final FilterSettings sobel;
  final int colorThreshold;
  final int searchThreshold;
  final int groupSize;
  final double angle;
  final double proportionThreshold;

  Settings copyWith({
    FilterSettings? grayscale,
    FilterSettings? sobel,
    int? colorThreshold,
    int? searchThreshold,
    int? groupSize,
    double? angle,
    double? proportionThreshold,
  }) {
    return Settings(
      grayscale: grayscale ?? this.grayscale,
      sobel: sobel ?? this.sobel,
      colorThreshold: colorThreshold ?? this.colorThreshold,
      searchThreshold: searchThreshold ?? this.searchThreshold,
      groupSize: groupSize ?? this.groupSize,
      angle: angle ?? this.angle,
      proportionThreshold: proportionThreshold ?? this.proportionThreshold,
    );
  }

  Settings change({
    double? grayscaleAmount,
    int? grayscaleMaskChannel,
    double? sobelAmount,
    int? sobelMaskChannel,
    int? colorThreshold,
    int? searchThreshold,
    int? groupSize,
    double? angle,
    double? proportionThreshold,
  }) {
    return copyWith(
      grayscale: grayscale.copyWith(
        amount: grayscaleAmount ?? grayscale.amount,
        maskChannel: grayscaleMaskChannel ?? grayscale.maskChannel,
      ),
      sobel: sobel.copyWith(
        amount: sobelAmount ?? sobel.amount,
        maskChannel: sobelMaskChannel ?? sobel.maskChannel,
      ),
      colorThreshold: colorThreshold ?? this.colorThreshold,
      searchThreshold: searchThreshold ?? this.searchThreshold,
      groupSize: groupSize ?? this.groupSize,
      angle: angle ?? this.angle,
      proportionThreshold: proportionThreshold ?? this.proportionThreshold,
    );
  }
}

class FilterSettings {
  const FilterSettings({
    required this.amount,
    required this.maskChannel,
  });

  final double amount;
  final int maskChannel;

  FilterSettings copyWith({
    double? amount,
    int? maskChannel,
  }) {
    return FilterSettings(
      amount: amount ?? this.amount,
      maskChannel: maskChannel ?? this.maskChannel,
    );
  }
}
