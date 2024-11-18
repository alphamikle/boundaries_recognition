extension PercentileList on List<num> {
  num percentile(int percentile) {
    if (isEmpty) {
      throw ArgumentError('The data list cannot be empty.');
    }

    if (percentile < 0 || percentile > 100) {
      throw ArgumentError('Percentile must be between 0 and 100.');
    }

    final List<num> sortedData = List.of(this)..sort();

    final double rank = (percentile / 100) * (sortedData.length - 1);

    final int lowerIndex = rank.floor();
    final int upperIndex = rank.ceil();

    if (lowerIndex == upperIndex) {
      return sortedData[lowerIndex];
    }

    final num lowerValue = sortedData[lowerIndex];
    final num upperValue = sortedData[upperIndex];
    return lowerValue + (upperValue - lowerValue) * (rank - lowerIndex);
  }

  num avg() {
    if (isEmpty) {
      return 0;
    }

    final num sum = fold(0, (num sum, num current) => sum + current);
    return sum / length;
  }
}
