import 'package:flutter/material.dart';

import '../navigator/router_delegate.dart';

NavigatorState get navigatorState =>
    AppRouterDelegate.instance.delegate.navigator;

BuildContext get currentContext => navigatorState.context;

ThemeData get currentTheme => Theme.of(currentContext);

bool get currentIsDark => currentTheme.brightness == Brightness.dark;

class Instances {
  const Instances._();

  static GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey();

  static final RouteObserver<Route<dynamic>> routeObserver =
      RouteObserver<Route<dynamic>>();
}
