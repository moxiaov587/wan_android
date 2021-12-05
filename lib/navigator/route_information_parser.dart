import 'package:flutter/material.dart';

import 'configuration.dart';
import 'route_name.dart';

class AppRouteInformationParser extends RouteInformationParser<Configuration> {
  @override
  Future<Configuration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final Uri uri = Uri.parse(routeInformation.location ?? '');

    final int length = uri.pathSegments.length;

    if (length == 0) {
      return Configuration.home();
    }

    if (length == 2) {
      final List<String> pathSegments = uri.pathSegments;

      if (pathSegments.first == RouteName.article.substring(1)) {
        return Configuration.article(uri: pathSegments.last);
      }

      return Configuration.unknown();
    }

    return Configuration.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(Configuration configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: RouteName.unknown);
    }

    if (configuration.isHome) {
      return const RouteInformation(location: RouteName.home);
    }

    if (configuration.isArticle) {
      return RouteInformation(
        location: '${RouteName.article}/${configuration.uri}',
      );
    }

    return null;
  }
}
