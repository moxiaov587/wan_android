import 'package:flutter/material.dart';

import '../navigator/router_delegate.dart';

NavigatorState get navigatorState => AppRouterDelegate.routerDelegate.navigator;

BuildContext get currentContext => navigatorState.context;

ThemeData get currentTheme => Theme.of(currentContext);

bool get currentIsDark => currentTheme.brightness == Brightness.dark;

class Instances {
  const Instances._();
}
