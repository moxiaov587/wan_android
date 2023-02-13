part of '../app_routes.dart';

@TypedGoRoute<HomeRoute>(path: '/:path(home|square|qa|project)')
class HomeRoute extends GoRouteData {
  const HomeRoute({required this.path});

  final HomePath path;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      HomeScreen(initialPath: path);
}

@TypedGoRoute<RootRoute>(path: '/')
class RootRoute extends GoRouteData {
  @override
  String redirect(BuildContext context, GoRouterState state) =>
      const HomeRoute(path: HomePath.home).location;
}
