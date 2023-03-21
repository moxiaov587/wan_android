import 'dart:developer' as dev;

import 'package:logging/logging.dart';

/// https://github.com/openjmu/OpenJMU/blob/master/lib/utils/log_utils.dart
class LogUtils {
  const LogUtils._();

  static const String _tag = 'LOG';

  static void i(dynamic message, {String tag = _tag, StackTrace? stackTrace}) {
    _printLog(message, '$tag ❕', stackTrace, level: Level.CONFIG);
  }

  static void d(dynamic message, {String tag = _tag, StackTrace? stackTrace}) {
    _printLog(message, '$tag 📣', stackTrace, level: Level.INFO);
  }

  static void w(dynamic message, {String tag = _tag, StackTrace? stackTrace}) {
    _printLog(message, '$tag ⚠️', stackTrace, level: Level.WARNING);
  }

  static void e(
    dynamic message, {
    String tag = _tag,
    StackTrace? stackTrace,
    bool withStackTrace = true,
  }) {
    _printLog(
      message,
      '$tag ❌',
      stackTrace,
      isError: true,
      level: Level.SEVERE,
      withStackTrace: withStackTrace,
    );
  }

  static void json(
    dynamic message, {
    String tag = _tag,
    StackTrace? stackTrace,
  }) {
    _printLog(message, '$tag 💠', stackTrace);
  }

  static void _printLog(
    dynamic message,
    String? tag,
    StackTrace? stackTrace, {
    bool isError = false,
    Level level = Level.ALL,
    bool withStackTrace = true,
  }) {
    if (isError) {
      dev.log(
        '${DateTime.now().millisecondsSinceEpoch} - An error occurred.',
        time: DateTime.now(),
        name: tag ?? _tag,
        level: level.value,
        error: message,
        stackTrace: stackTrace ??
            (isError && withStackTrace ? StackTrace.current : null),
      );
    } else {
      dev.log(
        '${DateTime.now().millisecondsSinceEpoch} - $message',
        time: DateTime.now(),
        name: tag ?? _tag,
        level: level.value,
        stackTrace: stackTrace ??
            (isError && withStackTrace ? StackTrace.current : null),
      );
    }
  }
}
