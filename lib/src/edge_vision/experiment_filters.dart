// import 'dart:math';
// import 'package:image/image.dart' as img;
//
// /// Function to apply the Canny filter
// img.Image applyCanny(img.Image image, {int lowThreshold = 50, int highThreshold = 150}) {
//   // 1. Apply Gaussian blur
//   image = img.gaussianBlur(image, radius: 2);
//
//   // 2. Apply Sobel filter to find gradients
//   img.Image sobelImage = img.sobel(image);
//
//   // 3. Non-Maximum Suppression to keep thin edge lines
//   final suppressedImage = nonMaximumSuppression(sobelImage);
//
//   // 4. Double Threshold and Hysteresis
//   final thresholdedImage = doubleThresholdAndHysteresis(suppressedImage, lowThreshold, highThreshold);
//
//   return thresholdedImage;
// }
//
// /// Non-Maximum Suppression to find thin edge lines
// img.Image nonMaximumSuppression(img.Image image) {
//   final result = img.Image.from(image);
//   for (int y = 1; y < image.height - 1; y++) {
//     for (int x = 1; x < image.width - 1; x++) {
//       final gradient = image.getPixel(x, y);
//       final angle = atan2(image.getPixel(x, y + 1) - image.getPixel(x, y - 1), image.getPixel(x + 1, y) - image.getPixel(x - 1, y));
//       final direction = (angle * (180 / pi)).abs() % 180;
//
//       bool isEdge = false;
//       if ((0 <= direction && direction < 22.5) || (157.5 <= direction && direction <= 180)) {
//         isEdge = gradient >= image.getPixel(x - 1, y) && gradient >= image.getPixel(x + 1, y);
//       } else if (22.5 <= direction && direction < 67.5) {
//         isEdge = gradient >= image.getPixel(x - 1, y - 1) && gradient >= image.getPixel(x + 1, y + 1);
//       } else if (67.5 <= direction && direction < 112.5) {
//         isEdge = gradient >= image.getPixel(x, y - 1) && gradient >= image.getPixel(x, y + 1);
//       } else if (112.5 <= direction && direction < 157.5) {
//         isEdge = gradient >= image.getPixel(x - 1, y + 1) && gradient >= image.getPixel(x + 1, y - 1);
//       }
//
//       if (!isEdge) {
//         result.setPixel(x, y, img.getColor(0, 0, 0));
//       }
//     }
//   }
//   return result;
// }
//
// /// Double Threshold and Hysteresis to highlight significant edges
// img.Image doubleThresholdAndHysteresis(img.Image image, int lowThreshold, int highThreshold) {
//   final result = img.Image.from(image);
//
//   for (int y = 0; y < image.height; y++) {
//     for (int x = 0; x < image.width; x++) {
//       final pixel = img.getRed(image.getPixel(x, y));
//       if (pixel >= highThreshold) {
//         result.setPixel(x, y, img.getColor(255, 255, 255)); // Strong edge
//       } else if (pixel >= lowThreshold) {
//         result.setPixel(x, y, img.getColor(127, 127, 127)); // Weak edge
//       } else {
//         result.setPixel(x, y, img.getColor(0, 0, 0)); // Non-edge
//       }
//     }
//   }
//
//   // Hysteresis: Suppress weak edges not connected to strong edges
//   for (int y = 1; y < result.height - 1; y++) {
//     for (int x = 1; x < result.width - 1; x++) {
//       if (img.getRed(result.getPixel(x, y)) == 127) {
//         if (hasStrongEdgeNeighbor(result, x, y)) {
//           result.setPixel(x, y, img.getColor(255, 255, 255));
//         } else {
//           result.setPixel(x, y, img.getColor(0, 0, 0));
//         }
//       }
//     }
//   }
//
//   return result;
// }
//
// /// Check for the presence of a strong edge neighbor
// bool hasStrongEdgeNeighbor(img.Image image, int x, int y) {
//   for (int i = -1; i <= 1; i++) {
//     for (int j = -1; j <= 1; j++) {
//       if (img.getRed(image.getPixel(x + i, y + j)) == 255) {
//         return true;
//       }
//     }
//   }
//   return false;
// }
