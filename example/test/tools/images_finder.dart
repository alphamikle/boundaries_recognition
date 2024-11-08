import 'package:boundaries_detector/src/utils/dataset.dart';
import 'package:boundaries_detector/src/utils/image_params_extractor.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';

typedef FoundImages = (List<Image>, List<String>);
typedef FoundImage = (Image, String);

Future<FoundImages> findImages(Set<String> imageColors, Set<String> backgroundColors) async {
  final List<Image> targetImages = [];
  final List<String> names = [];

  for (final String imagePath in dataset) {
    final ImageParams imageParams = extractImageParams(imagePath);

    final String card = imageParams.card;
    final String background = imageParams.background;
    final String size = imageParams.size;
    final String index = imageParams.index;

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

Future<FoundImage> findImage(String path) async {
  final String filePath = join(current, path);
  final Image? image = await decodeJpgFile(filePath);

  if (image == null) {
    throw Exception('Did not found image with path [$filePath]');
  }

  return (image, path);
}
