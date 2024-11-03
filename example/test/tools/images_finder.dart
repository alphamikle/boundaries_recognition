import 'package:boundaries_detector/src/utils/dataset.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';

Future<List<Image>> findImages(Set<String> imageColors, Set<String> backgroundColors) async {
  final RegExp imagePathRegExp = RegExp(r'(?<size>\d+x\d+)/(?<card>[a-z]+)_(?<background>[a-z]+)_(?<index>\d+)\.jpg$');
  final List<Image> targetImages = [];

  for (final String imagePath in dataset) {
    final RegExpMatch? match = imagePathRegExp.firstMatch(imagePath);
    if (match == null) {
      continue;
    }

    final String card = match.namedGroup('card')!;
    final String background = match.namedGroup('background')!;

    if ((imageColors.contains(card) || imageColors.isEmpty) && (backgroundColors.contains(background) || backgroundColors.isEmpty)) {
      targetImages.add((await decodeJpgFile(join(current, imagePath)))!);
    }
  }

  return targetImages;
}
