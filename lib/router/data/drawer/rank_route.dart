part of '../app_routes.dart';

@TypedGoRoute<RankRoute>(path: '/rank')
class RankRoute extends GoRouteData {
  const RankRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const RankScreen();
}
