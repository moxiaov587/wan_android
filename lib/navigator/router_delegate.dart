import 'package:flutter/material.dart';

import '../contacts/instances.dart';
import '../screen/home/home.dart';
import '../screen/unknown.dart';
import 'configuration.dart';
import 'page.dart';
import 'route_name.dart';

class AppRouterDelegate extends RouterDelegate<Configuration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Configuration> {
  AppRouterDelegate() : _navigatorKey = Instances.navigatorKey;

  final GlobalKey<NavigatorState> _navigatorKey;

  bool showUnknown = false;

  String? _articleUri;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Configuration? get currentConfiguration {
    if (showUnknown) {
      return Configuration.unknown();
    }

    if (_articleUri == null) {
      return Configuration.home();
    }

    if (_articleUri != null) {
      return Configuration.article(uri: _articleUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Page<dynamic>> pages = <Page<dynamic>>[
      MaterialPage<void>(
        key: ValueKey<String>(RouteName.home.substring(1).toUpperCase()),
        child: HomeScreen(
          onTapped: _handleArticleTapped,
        ),
      ),
      if (showUnknown)
        MaterialPage<void>(
          key: ValueKey<String>(RouteName.unknown.substring(1).toUpperCase()),
          child: const UnknownScreen(),
        ),
      if (_articleUri != null) ArticlePage(uri: _articleUri!),
    ];

    return Navigator(
      key: _navigatorKey,
      pages: pages,
      onPopPage: (Route<dynamic> route, dynamic result) {
        if (!route.didPop(result)) {
          return false;
        }

        _articleUri = null;

        showUnknown = false;

        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(Configuration configuration) async {
    if (configuration.isUnknown) {
      _articleUri = null;
      showUnknown = true;
      return;
    }

    if (configuration.isArticle) {
      /// TODO: verify uri
      ///

      _articleUri = configuration.uri;
    } else {
      _articleUri = null;
    }

    showUnknown = false;
  }

  void _handleArticleTapped(String uri) {
    _articleUri = uri;
    notifyListeners();
  }
}
