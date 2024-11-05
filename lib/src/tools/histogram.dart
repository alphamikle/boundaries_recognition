typedef HistogramMeanAndVariance = ({double mean, double variance});
typedef LevelsHistogramsMeanAndVariance = ({
  HistogramMeanAndVariance red,
  HistogramMeanAndVariance green,
  HistogramMeanAndVariance blue,
  HistogramMeanAndVariance luminance,
});
typedef ChannelsHistograms = ({List<int> red, List<int> green, List<int> blue, List<int> luminance});

extension type Histogram(ChannelsHistograms _histograms) {
  List<int> get red => _histograms.red;
  List<int> get green => _histograms.green;
  List<int> get blue => _histograms.blue;
  List<int> get luminance => _histograms.luminance;

  LevelsHistogramsMeanAndVariance meanAndVariance() {
    final int redTotalPixels = red.reduce((int a, int b) => a + b);
    final int greenTotalPixels = green.reduce((int a, int b) => a + b);
    final int blueTotalPixels = blue.reduce((int a, int b) => a + b);
    final int luminanceTotalPixels = luminance.reduce((int a, int b) => a + b);

    double redMean = 0;
    double greenMean = 0;
    double blueMean = 0;
    double luminanceMean = 0;

    for (int i = 0; i < luminance.length; i++) {
      redMean += i * red[i];
      greenMean += i * green[i];
      blueMean += i * blue[i];
      luminanceMean += i * luminance[i];
    }

    redMean /= redTotalPixels;
    greenMean /= greenTotalPixels;
    blueMean /= blueTotalPixels;
    luminanceMean /= luminanceTotalPixels;

    double redVariance = 0;
    double greenVariance = 0;
    double blueVariance = 0;
    double luminanceVariance = 0;

    for (int i = 0; i < luminance.length; i++) {
      redVariance += ((i - redMean) * (i - redMean)) * red[i];
      greenVariance += ((i - greenMean) * (i - greenMean)) * green[i];
      blueVariance += ((i - blueMean) * (i - blueMean)) * blue[i];
      luminanceVariance += ((i - luminanceMean) * (i - luminanceMean)) * luminance[i];
    }

    redVariance /= redTotalPixels;
    greenVariance /= greenTotalPixels;
    blueVariance /= blueTotalPixels;
    luminanceVariance /= luminanceTotalPixels;

    return (
      red: (mean: redMean, variance: redVariance),
      green: (mean: greenMean, variance: greenVariance),
      blue: (mean: blueMean, variance: blueVariance),
      luminance: (mean: luminanceMean, variance: luminanceVariance),
    );
  }
}
