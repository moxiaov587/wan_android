part of '../app_routes.dart';

@TypedGoRoute<HomeRoute>(path: '/:path(home|square|qa|project)')
class HomeRoute extends GoRouteData {
  const HomeRoute({required this.path});

  final HomePath path;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      HomeScreen(initialPath: path);
}
