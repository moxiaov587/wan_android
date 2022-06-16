import 'dart:async' show Timer;

import 'package:flutter/foundation.dart';

VoidCallback debounce(
  VoidCallback callback, {
  Duration duration = const Duration(seconds: 1),
  bool triggerNow = true,
}) {
  assert(duration > Duration.zero);
  Timer? debounce;

  return () {
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }

    if (triggerNow) {
      final bool exec = debounce == null;

      debounce = Timer(duration, () {
        debounce = null;
      });

      if (exec) {
        callback.call();
      }
    } else {
      debounce = Timer(duration, () {
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
  Timer? throttle;

  return () {
    if (throttle?.isActive ?? false) {
      return;
    }
    callback.call();
    throttle = Timer(duration, () {});
  };
}
