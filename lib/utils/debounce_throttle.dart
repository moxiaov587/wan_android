import 'dart:async' show Timer;

import 'package:flutter/foundation.dart';

VoidCallback debounce(
  VoidCallback callback, [
  Duration duration = const Duration(seconds: 1),
]) {
  assert(callback != null);
  assert(duration != null && duration > Duration.zero);
  Timer? _debounce;
  return () {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(duration, () {
      callback.call();
    });
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
