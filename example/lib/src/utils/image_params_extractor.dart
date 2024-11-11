typedef ImageParams = ({String card, String background, String size, String index});

ImageParams extractImageParams(String imagePath) {
  final RegExp imagePathRegExp = RegExp(r'(?<size>\d+x\d+)/(?<card>[a-z]+)_(?<background>[a-z]+)_(?<index>\d+)\.jpg$');
  final RegExp alternativePathRegExp = RegExp(r'image_(?<card>[a-z]+)_on_(?<background>[a-z]+)_(?<index>\d+)_');
  final RegExpMatch? match = imagePathRegExp.firstMatch(imagePath) ?? alternativePathRegExp.firstMatch(imagePath);

  if (match == null) {
    throw Exception('Incorrect image name or path [$imagePath]');
  }

  final String card = match.namedGroup('card')!;
  final String background = match.namedGroup('background')!;
  final String size = match.groupNames.contains('size') ? match.namedGroup('size') ?? '' : '';
  final String index = match.namedGroup('index')!;

  return (
    card: card,
    background: background,
    size: size,
    index: index,
  );
}

extension ExtendedImageParams on ImageParams {
  ImageParams copyWith({
    String? card,
    String? background,
    String? size,
    String? index,
  }) {
    return (card: card ?? this.card, background: background ?? this.background, size: size ?? this.size, index: index ?? this.index);
  }
}
