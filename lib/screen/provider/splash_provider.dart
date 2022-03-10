import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<SplashNotifier, bool> splashProvider =
    StateNotifierProvider<SplashNotifier, bool>((_) => SplashNotifier());

class SplashNotifier extends StateNotifier<bool> {
  SplashNotifier() : super(false);

  void initFinished() {
    state = true;
  }
}
