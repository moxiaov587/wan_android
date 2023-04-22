import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../screen/drawer/home_drawer.dart';
import '../contacts/instances.dart';
import '../database/app_database.dart';
import '../extensions/extensions.dart' show BuildContextExtension;
import '../screen/authorized/provider/authorized_provider.dart';
import '../screen/home/home_screen.dart';
import 'data/app_routes.dart';

part 'app_router.g.dart';
part 'page/app_page.dart';

@Riverpod(dependencies: <Object>[Authorized])
Raw<GoRouter> appRouter(AppRouterRef ref) {
  final GoRouter router = GoRouter(
    navigatorKey: Instances.rootNavigatorKey,
    initialLocation: const HomeRoute(path: HomePath.home).location,
    debugLogDiagnostics: kDebugMode,
    redirect: (BuildContext context, GoRouterState state) {
      if (<String>[
        const MyPointsRoute().location,
        const MyCollectionsRoute(type: CollectionType.article).location,
        const MyCollectionsRoute(type: CollectionType.website).location,
        const MyShareRoute().location,
      ].contains(state.location)) {
        return ref.read(authorizedProvider).valueOrNull != null
            ? null
            : const LoginRoute().location;
      }

      return null;
    },
    errorBuilder: const UnknownRoute().build,
    observers: <NavigatorObserver>[
      FlutterSmartDialog.observer,
      Instances.routeObserver,
    ],
    routes: $appRoutes,
  );

  ref.onDispose(router.dispose);

  return router;
}
