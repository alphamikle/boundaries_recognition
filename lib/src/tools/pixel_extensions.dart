import 'package:image/image.dart';

extension ExtendedPixel on Pixel {
  bool get isWhite => r == 255 && g == 255 && b == 255;

  bool get isBlack => r == 0 && g == 0 && b == 0;
}
