import 'package:flutter/material.dart';

NavigatorState get navigatorState => Instances.navigatorKey.currentState!;

BuildContext get currentContext => navigatorState.context;

ThemeData get currentTheme => Theme.of(currentContext);

bool get currentIsDark => currentTheme.brightness == Brightness.dark;

class Instances {
  const Instances._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
