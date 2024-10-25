import 'package:image/image.dart' as i;

void threshold(i.Image image, int threshold) {
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final i.Pixel pixel = image.getPixel(x, y);
      final num brightness = i.getLuminance(pixel);

      if (brightness > threshold) {
        image.setPixel(x, y, i.ColorInt8.rgb(255, 255, 255));
      } else {
        image.setPixel(x, y, i.ColorInt8.rgb(0, 0, 0));
      }
    }
  }
}
