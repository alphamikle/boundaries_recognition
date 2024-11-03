import 'dart:async';

import 'package:edge_vision/edge_vision.dart';

typedef SettingsCallback = FutureOr<void> Function(Settings settings, int index, int total);

int calculateIterationsAmount({
  required Settings initial,
  required Settings end,
  required Settings step,
}) {
  final Settings(
    searchMatrixSize: iSMS,
    minObjectSize: iMOS,
    distortionAngleThreshold: iDAT,
    skewnessThreshold: iST,
    blackWhiteThreshold: iBWT,
    grayscaleAmount: iGA,
    sobelAmount: iSA,
    blurRadius: iBR,
  ) = initial;

  final Settings(
    searchMatrixSize: eSMS,
    minObjectSize: eMOS,
    distortionAngleThreshold: eDAT,
    skewnessThreshold: eST,
    blackWhiteThreshold: eBWT,
    grayscaleAmount: eGA,
    sobelAmount: eSA,
    blurRadius: eBR,
  ) = end;

  final Settings(
    searchMatrixSize: sSMS,
    minObjectSize: sMOS,
    distortionAngleThreshold: sDAT,
    skewnessThreshold: sST,
    blackWhiteThreshold: sBWT,
    grayscaleAmount: sGA,
    sobelAmount: sSA,
    blurRadius: sBR,
  ) = step;

  final double amount = ((eSMS - iSMS) / sSMS) *
      ((eMOS - iMOS) / sMOS) *
      ((eDAT - iDAT) / sDAT) *
      ((eST - iST) / sST) *
      ((eBWT - iBWT) / sBWT) *
      ((eGA - iGA) / sGA) *
      ((eSA - iSA) / sSA) *
      ((eBR - iBR) / sBR);
  return amount.round();
}

Future<void> iterateOverSettings({
  required SettingsCallback callback,
  required Settings initial,
  required Settings end,
  required Settings step,
}) async {
  final Settings(
    searchMatrixSize: iSMS,
    minObjectSize: iMOS,
    distortionAngleThreshold: iDAT,
    skewnessThreshold: iST,
    blackWhiteThreshold: iBWT,
    grayscaleAmount: iGA,
    sobelAmount: iSA,
    blurRadius: iBR,
  ) = initial;

  final Settings(
    searchMatrixSize: eSMS,
    minObjectSize: eMOS,
    distortionAngleThreshold: eDAT,
    skewnessThreshold: eST,
    blackWhiteThreshold: eBWT,
    grayscaleAmount: eGA,
    sobelAmount: eSA,
    blurRadius: eBR,
  ) = end;

  final Settings(
    searchMatrixSize: sSMS,
    minObjectSize: sMOS,
    distortionAngleThreshold: sDAT,
    skewnessThreshold: sST,
    blackWhiteThreshold: sBWT,
    grayscaleAmount: sGA,
    sobelAmount: sSA,
    blurRadius: sBR,
  ) = step;

  int index = 0;
  final int total = calculateIterationsAmount(initial: initial, end: end, step: step);

  for (int sms = iSMS; sms < eSMS; sms += sSMS) {
    for (int mos = iMOS; mos < eMOS; mos += sMOS) {
      for (double dat = iDAT; dat < eDAT; dat += sDAT) {
        for (double st = iST; st < eST; st += sST) {
          for (int bwt = iBWT; bwt < eBWT; bwt += sBWT) {
            for (double ga = iGA; ga < eGA; ga += sGA) {
              for (double sa = iSA; sa < eSA; sa += sSA) {
                for (int br = iBR; br < eBR; br += sBR) {
                  final Settings settings = Settings(
                    searchMatrixSize: sms,
                    minObjectSize: mos,
                    distortionAngleThreshold: dat,
                    skewnessThreshold: st,
                    blackWhiteThreshold: bwt,
                    grayscaleAmount: ga,
                    sobelAmount: sa,
                    blurRadius: br,
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
}
