part of '../../app_routes.dart';

@TypedGoRoute<SettingsRoute>(
  path: '/settings',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<LanguagesRoute>(path: 'languages'),
    TypedGoRoute<StorageRoute>(path: 'storage'),
  ],
)
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}
