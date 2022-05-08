import 'dart:async' show Timer;

import 'package:flutter/foundation.dart';

VoidCallback debounce(
  VoidCallback callback, {
  Duration duration = const Duration(seconds: 1),
  bool triggerNow = true,
}) {
  assert(duration > Duration.zero);
  Timer? _debounce;

  return () {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    if (triggerNow) {
      final bool exec = _debounce == null;

      _debounce = Timer(duration, () {
        _debounce = null;
      });

      if (exec) {
        callback.call();
      }
    } else {
      _debounce = Timer(duration, () {
        callback.call();
      });
    }
  };
}

VoidCallback throttle(
  VoidCallback callback, [
  Duration duration = const Duration(seconds: 1),
]) {
  assert(callback != null);
  assert(duration != null && duration > Duration.zero);
  Timer? _throttle;

  return () {
    if (_throttle?.isActive ?? false) {
      return;
    }
    callback.call();
    _throttle = Timer(duration, () {});
  };
}
