import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

abstract final class Throttle {
  static final Map<String, Timer> _timers = {};
  static final Map<String, int> _operationsInRun = {};

  static Future<void> run(String id, AsyncCallback callback, {Duration delay = const Duration(milliseconds: 1000 ~/ 15)}) async {
    if (_timers.containsKey(id) || _operationsInRun.containsKey(id)) {
      if (_timers.containsKey(id) == false) {
        final int duration = DateTime.now().microsecondsSinceEpoch - _operationsInRun[id]!;
        log('Operation [$id] taking [${duration / 1000}ms], which is more than desired delay [${delay.inMicroseconds / 1000}ms]');
      }

      return;
    }

    _operationsInRun[id] = DateTime.now().microsecondsSinceEpoch;

    _timers[id] = Timer(delay, () {
      _timers.remove(id);
    });

    try {
      await callback();
    } catch (error, stackTrace) {
      log('Error on throttle run', error: error, stackTrace: stackTrace);
    }

    _operationsInRun.remove(id);
  }
}
