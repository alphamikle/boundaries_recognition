import 'dart:async';

import 'package:edge_vision/edge_vision.dart';

typedef SettingsCallback = FutureOr<void> Function(EdgeVisionSettings settings, int index, int total);
typedef SumCallback = num Function(EdgeVisionSettings settings);
typedef IteratorCallback<T extends num> = FutureOr<void> Function(T value);

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

Future<int> calculateIterationsAmountV2({
  required EdgeVisionSettings initial,
  required EdgeVisionSettings target,
  required EdgeVisionSettings step,
}) async {
  double totalSum = 0;

  await iterateOverSettings(callback: (settings, index, total) => totalSum++, initial: initial, target: target, step: step, total: 0);

  return totalSum.toInt();
}

Future<void> iterateOverSettings({
  required SettingsCallback callback,
  required EdgeVisionSettings initial,
  required EdgeVisionSettings target,
  required EdgeVisionSettings step,
  required int total,
}) async {
  final EdgeVisionSettings(
    sobelLevel: initialSobelLevel,
    sobelAmount: initialSobelAmount,
    blurRadius: initialBlurRadius,
    blackWhiteThreshold: initialBlackWhiteThreshold,
    luminanceThreshold: initialLuminanceThreshold,
    searchMatrixSize: initialSearchMatrixSize,
    grayscaleLevel: initialGrayscaleLevel,
    grayscaleAmount: initialGrayscaleAmount,
  ) = initial;

  final EdgeVisionSettings(
    sobelLevel: targetSobelLevel,
    sobelAmount: targetSobelAmount,
    blurRadius: targetBlurRadius,
    blackWhiteThreshold: targetBlackWhiteThreshold,
    luminanceThreshold: targetLuminanceThreshold,
    searchMatrixSize: targetSearchMatrixSize,
    grayscaleLevel: targetGrayscaleLevel,
    grayscaleAmount: targetGrayscaleAmount,
  ) = target;

  final EdgeVisionSettings(
    sobelLevel: stepSobelLevel,
    sobelAmount: stepSobelAmount,
    blurRadius: stepBlurRadius,
    blackWhiteThreshold: stepBlackWhiteThreshold,
    luminanceThreshold: stepLuminanceThreshold,
    searchMatrixSize: stepSearchMatrixSize,
    grayscaleLevel: stepGrayscaleLevel,
    grayscaleAmount: stepGrayscaleAmount,
  ) = step;

  int index = 0;

  await _propertyIterator(
    initial: initialSobelLevel,
    target: targetSobelLevel,
    step: stepSobelLevel,
    callback: (double sobelLevel) async {
      await _propertyIterator(
        initial: initialSobelAmount,
        target: targetSobelAmount,
        step: stepSobelAmount,
        callback: (int sobelAmount) async {
          await _propertyIterator(
            initial: initialBlurRadius,
            target: targetBlurRadius,
            step: stepBlurRadius,
            callback: (int blurRadius) async {
              await _propertyIterator(
                initial: initialBlackWhiteThreshold,
                target: targetBlackWhiteThreshold,
                step: stepBlackWhiteThreshold,
                callback: (int blackWhiteThreshold) async {
                  await _propertyIterator(
                    initial: initialLuminanceThreshold,
                    target: targetLuminanceThreshold,
                    step: stepLuminanceThreshold,
                    callback: (double luminanceThreshold) async {
                      await _propertyIterator(
                        initial: initialSearchMatrixSize,
                        target: targetSearchMatrixSize,
                        step: stepSearchMatrixSize,
                        callback: (int searchMatrixSize) async {
                          await _propertyIterator(
                            initial: initialGrayscaleLevel,
                            target: targetGrayscaleLevel,
                            step: stepGrayscaleLevel,
                            callback: (double grayscaleLevel) async {
                              await _propertyIterator(
                                initial: initialGrayscaleAmount,
                                target: targetGrayscaleAmount,
                                step: stepGrayscaleAmount,
                                callback: (int grayscaleAmount) async {
                                  final EdgeVisionSettings settings = EdgeVisionSettings(
                                    searchMatrixSize: searchMatrixSize,
                                    blackWhiteThreshold: blackWhiteThreshold,
                                    sobelLevel: sobelLevel,
                                    sobelAmount: sobelAmount,
                                    blurRadius: blurRadius,
                                    luminanceThreshold: luminanceThreshold,
                                    grayscaleLevel: grayscaleLevel,
                                    grayscaleAmount: grayscaleAmount,
                                    minObjectSize: initial.minObjectSize,
                                    directionAngleLevel: initial.directionAngleLevel,
                                    skewnessThreshold: initial.skewnessThreshold,
                                    areaThreshold: initial.areaThreshold,
                                    symmetricAngleThreshold: initial.symmetricAngleThreshold,
                                    maxImageSize: initial.maxImageSize,
                                  );

                                  await callback(settings, index, total);

                                  index++;
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

Future<void> _propertyIterator<T extends num>({
  required T initial,
  required T target,
  required T step,
  required IteratorCallback<T> callback,
}) async {
  if (step == 0) {
    await callback(initial);
  } else {
    if (initial is int) {
      for (int i = initial as int; i <= (target as int); i += step as int) {
        await callback(i as T);
      }
    } else {
      for (double i = initial as double; i <= (target as double); i += step as double) {
        await callback(i as T);
      }
    }
  }
}
