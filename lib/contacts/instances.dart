import 'package:flutter/material.dart';

NavigatorState get navigatorState => Instances.rootNavigatorKey.currentState!;

BuildContext get currentContext => navigatorState.context;

ThemeData get currentTheme => Theme.of(currentContext);

bool get currentIsDark => currentTheme.brightness == Brightness.dark;

class Instances {
  const Instances._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final RouteObserver<Route<dynamic>> routeObserver =
      RouteObserver<Route<dynamic>>();
}
