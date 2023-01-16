part of '../app_routes.dart';

@TypedGoRoute<MyPointsRoute>(path: '/my/points')
class MyPointsRoute extends GoRouteData {
  const MyPointsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MyPointsScreen();
}
