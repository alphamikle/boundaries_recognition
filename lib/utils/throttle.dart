import 'dart:async';

import 'package:flutter/material.dart';

abstract final class Throttle {
  static final Map<String, Timer> _timers = {};

  static void run(String id, VoidCallback callback, {Duration delay = const Duration(milliseconds: 1000 ~/ 15)}) {
    if (_timers.containsKey(id)) {
      return;
    }

    _timers[id] = Timer(delay, () {
      _timers.remove(id);
    });

    callback();
  }
}
