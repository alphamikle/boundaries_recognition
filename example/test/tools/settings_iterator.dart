import 'dart:async';

import 'package:edge_vision/edge_vision.dart';

typedef SettingsCallback = FutureOr<void> Function(EdgeVisionSettings settings, int index, int total);
typedef SumCallback = num Function(EdgeVisionSettings settings);
typedef IteratorCallback = void Function(int index, num value);

int calculateIterationsAmount({
  required EdgeVisionSettings initial,
  required EdgeVisionSettings target,
  required EdgeVisionSettings step,
}) {
  double totalSum = 0;

  final List<num> initialFields = initial.fields;
  final List<num> targetFields = target.fields;
  final List<num> stepFields = step.fields;

  for (int i = 0; i < initialFields.length; i++) {
    final num initialValue = initialFields[i];
    final num targetValue = targetFields[i];
    final num stepValue = stepFields[i];

    if (stepValue == 0) {
      totalSum += initialFields.length;
      continue;
    }

    final double sumOfSteps = ((targetValue - initialValue) / stepValue).abs();
    totalSum += sumOfSteps;
  }

  return totalSum.toInt();
}

Future<void> iterateOverSettings({
  required SettingsCallback callback,
  required EdgeVisionSettings initial,
  required EdgeVisionSettings target,
  required EdgeVisionSettings step,
}) async {
  final EdgeVisionSettings(
    blackWhiteThreshold: iBWT,
    sobelLevel: iSL,
    sobelAmount: iSA,
    luminanceThreshold: iLT,
    blurRadius: iBR,
  ) = initial;

  final EdgeVisionSettings(
    blackWhiteThreshold: tBWT,
    sobelLevel: tSL,
    sobelAmount: tSA,
    luminanceThreshold: tLT,
    blurRadius: tBR,
  ) = target;

  final EdgeVisionSettings(
    blackWhiteThreshold: sBWT,
    sobelLevel: sSL,
    sobelAmount: sSA,
    luminanceThreshold: sLT,
    blurRadius: sBR,
  ) = step;

  int index = 0;
  final int total = calculateIterationsAmount(initial: initial, target: target, step: step);

  print('Total amount of variants: $total');

  for (num bwt = iBWT; bwt <= tBWT; bwt += sBWT) {
    for (num sl = iSL; sl <= tSL; sl += sSL) {
      for (num sa = iSA; sa <= tSA; sa += sSA) {
        for (num lt = iLT; lt <= tLT; lt += sLT) {
          for (num br = iBR; br <= tBR; br += sBR) {
            final EdgeVisionSettings settings = EdgeVisionSettings(
              searchMatrixSize: initial.searchMatrixSize,
              minObjectSize: initial.minObjectSize,
              directionAngleLevel: initial.directionAngleLevel,
              skewnessThreshold: initial.skewnessThreshold,
              blackWhiteThreshold: bwt.toInt(),
              grayscaleLevel: initial.grayscaleLevel,
              grayscaleAmount: initial.grayscaleAmount,
              sobelLevel: sl.toDouble(),
              sobelAmount: sa.toInt(),
              blurRadius: br.toInt(),
              areaThreshold: initial.areaThreshold,
              symmetricAngleThreshold: initial.symmetricAngleThreshold,
              luminanceThreshold: lt.toDouble(),
            );

            await callback(settings, index, total);

            index++;
          }
        }
      }
    }
  }
}
