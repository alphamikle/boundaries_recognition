typedef ImageParams = ({String card, String background, String size, String index});

ImageParams extractImageParams(String imagePath) {
  final RegExp imagePathRegExp = RegExp(r'(?<size>\d+x\d+)/(?<card>[a-z]+)_(?<background>[a-z]+)_(?<index>\d+)\.jpg$');
  final RegExpMatch? match = imagePathRegExp.firstMatch(imagePath);

  if (match == null) {
    throw Exception('Incorrect image name or path [$imagePath]');
  }

  final String card = match.namedGroup('card')!;
  final String background = match.namedGroup('background')!;
  final String size = match.namedGroup('size')!;
  final String index = match.namedGroup('index')!;

  return (
    card: card,
    background: background,
    size: size,
    index: index,
  );
}
