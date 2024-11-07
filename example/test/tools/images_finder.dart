import 'package:boundaries_detector/src/utils/dataset.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';

typedef FoundImages = (List<Image>, List<String>);

Future<FoundImages> findImages(Set<String> imageColors, Set<String> backgroundColors) async {
  final RegExp imagePathRegExp = RegExp(r'(?<size>\d+x\d+)/(?<card>[a-z]+)_(?<background>[a-z]+)_(?<index>\d+)\.jpg$');

  final List<Image> targetImages = [];
  final List<String> names = [];

  for (final String imagePath in dataset) {
    final RegExpMatch? match = imagePathRegExp.firstMatch(imagePath);

    if (match == null) {
      print('Incorrect image name or path [$imagePath]');
      continue;
    }

    final String card = match.namedGroup('card')!;
    final String background = match.namedGroup('background')!;
    final String size = match.namedGroup('size')!;
    final String index = match.namedGroup('index')!;

    if ((imageColors.contains(card) || imageColors.isEmpty) && (backgroundColors.contains(background) || backgroundColors.isEmpty)) {
      final String filePath = join(current, imagePath);
      final Image? image = await decodeJpgFile(filePath);

      if (image == null) {
        throw Exception('Did not found image with path [$filePath]');
      }

      targetImages.add(image);
      names.add('${size}_${card}_${background}_$index');
    }
  }

  return (targetImages, names);
}
