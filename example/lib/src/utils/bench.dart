import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

typedef MeasureCallback = FutureOr<void> Function();

final Map<String, int> _benchKeys = {};

final Map<String, int> _chains = {};

void start(String id) => _benchKeys[id] = DateTime.now().microsecondsSinceEpoch;

double stop(
  String id, {
  bool clear = false,
}) {
  final int? start = _benchKeys[id];
  if (start == null) {
    return 0;
  }

  final int now = DateTime.now().microsecondsSinceEpoch;
  final double diff = (now - start) / 1000;

  log('$id: ${diff}ms', name: 'BENCH');

  if (clear) {
    _benchKeys.remove(id);
  }

  return diff;
}

FutureOr<(double, double?)> measure(
  String id,
  MeasureCallback callback, {
  String? chain,
  bool abortChain = false,
}) {
  int? now;
  ValueGetter<double?>? chainCallback;
  if (chain != null) {
    now = DateTime.now().microsecondsSinceEpoch;

    chainCallback = () {
      if (now != null) {
        final int diff = DateTime.now().microsecondsSinceEpoch - now;
        _chains[chain] = (_chains[chain] ?? 0) + diff;
        if (abortChain) {
          final int? sum = _chains[chain];
          if (sum != null) {
            final double sumMs = sum / 1000;
            log('$chain ⛓️‍💥 $id: ${sumMs}ms', name: 'BENCH');
            return sumMs;
          }
        }
      }
      return null;
    };
  }

  start(id);

  final FutureOr<void> result = callback();

  if (result is Future) {
    return result.then((_) {
      final double diff = stop(id);
      final double? sum = chainCallback?.call();
      return (diff, sum);
    });
  }
  final double diff = stop(id);
  final double? sum = chainCallback?.call();
  return (diff, sum);
}
