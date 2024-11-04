import 'dart:async';

import 'package:edge_vision/edge_vision.dart';

typedef SettingsCallback = FutureOr<void> Function(EdgeVisionSettings settings, int index, int total);

int calculateIterationsAmount({
  required EdgeVisionSettings initial,
  required EdgeVisionSettings end,
  required EdgeVisionSettings step,
}) {
  final EdgeVisionSettings(
    symmetricAngleThreshold: iSAT,
    blackWhiteThreshold: iBWT,
    grayscaleLevel: iGL,
    grayscaleAmount: iGA,
    sobelLevel: iSL,
    sobelAmount: iSA,
    blurRadius: iBR,
  ) = initial;

  final EdgeVisionSettings(
    symmetricAngleThreshold: eSAT,
    blackWhiteThreshold: eBWT,
    grayscaleLevel: eGL,
    grayscaleAmount: eGA,
    sobelLevel: eSL,
    sobelAmount: eSA,
    blurRadius: eBR,
  ) = end;

  final EdgeVisionSettings(
    symmetricAngleThreshold: sSAT,
    blackWhiteThreshold: sBWT,
    grayscaleLevel: sGL,
    grayscaleAmount: sGA,
    sobelLevel: sSL,
    sobelAmount: sSA,
    blurRadius: sBR,
  ) = step;

  final double amount = ((eBWT - iBWT) / sBWT) * ((eGL - iGL) / sGL) * ((eGA - iGA) / sGA) * ((eSL - iSL) / sSL) * ((eSA - iSA) / sSA) * ((eBR - iBR) / sBR);
  return amount.round();
}

Future<void> iterateOverSettings({
  required SettingsCallback callback,
  required EdgeVisionSettings initial,
  required EdgeVisionSettings end,
  required EdgeVisionSettings step,
}) async {
  final EdgeVisionSettings(
    areaThreshold: dAT,
    minObjectSize: dMOS,
    skewnessThreshold: dST,
    searchMatrixSize: dSMS,
    directionAngleLevel: dDAL,
  ) = initial;

  final EdgeVisionSettings(
    symmetricAngleThreshold: iSAT,
    blackWhiteThreshold: iBWT,
    grayscaleLevel: iGL,
    grayscaleAmount: iGA,
    sobelLevel: iSL,
    sobelAmount: iSA,
    blurRadius: iBR,
  ) = initial;

  final EdgeVisionSettings(
    symmetricAngleThreshold: eSAT,
    blackWhiteThreshold: eBWT,
    grayscaleLevel: eGL,
    grayscaleAmount: eGA,
    sobelLevel: eSL,
    sobelAmount: eSA,
    blurRadius: eBR,
  ) = end;

  final EdgeVisionSettings(
    symmetricAngleThreshold: sSAT,
    blackWhiteThreshold: sBWT,
    grayscaleLevel: sGL,
    grayscaleAmount: sGA,
    sobelLevel: sSL,
    sobelAmount: sSA,
    blurRadius: sBR,
  ) = step;

  int index = 0;
  final int total = calculateIterationsAmount(initial: initial, end: end, step: step);

  for (double sat = iSAT; sat <= eSAT; sat += sSAT) {
    for (int bwt = iBWT; bwt <= eBWT; bwt += sBWT) {
      for (double gl = iGL; gl <= eGL; gl += sGL) {
        for (int ga = iGA; ga <= eGA; ga += sGA) {
          for (int sa = iSA; sa <= eSA; sa += sSA) {
            for (double sl = iSL; sl <= eSL; sl += sSL) {
              for (int br = iBR; br <= eBR; br += sBR) {
                final EdgeVisionSettings settings = EdgeVisionSettings(
                  searchMatrixSize: dSMS,
                  minObjectSize: dMOS,
                  directionAngleLevel: dDAL,
                  skewnessThreshold: dST,
                  blackWhiteThreshold: bwt,
                  grayscaleLevel: gl,
                  grayscaleAmount: ga,
                  sobelLevel: sl,
                  sobelAmount: sa,
                  blurRadius: br,
                  areaThreshold: dAT,
                  symmetricAngleThreshold: sat,
                );

                await callback(settings, index, total);

                index++;
              }
            }
          }
        }
      }
    }
  }
}
