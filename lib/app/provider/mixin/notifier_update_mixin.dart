import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin NotifierUpdateMixin<T> on Notifier<T> {
  T update(T Function(T) callback) => state = callback(state);
}

mixin AutoDisposeNotifierUpdateMixin<T> on AutoDisposeNotifier<T> {
  T update(T Function(T) callback) => state = callback(state);
}
