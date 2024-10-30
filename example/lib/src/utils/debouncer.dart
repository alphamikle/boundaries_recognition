import 'dart:async';

import 'package:flutter/foundation.dart';

typedef DebouncedCallback = Future<void> Function(AsyncCallback callback);

abstract final class Debouncer {
  const Debouncer._();

  static final Map<String, Timer> _timers = {};

  static Future<void> run(String id, AsyncCallback callback, {Duration delay = const Duration(milliseconds: 500)}) async {
    _timers[id]?.cancel();
    _timers.remove(id);

    _timers[id] = Timer(delay, () async {
      _timers.remove(id);
      await callback();
    });
  }

  static DebouncedCallback create(String id, {Duration delay = const Duration(milliseconds: 500)}) {
    return (AsyncCallback callback) {
      return run(id, callback, delay: delay);
    };
  }
}
