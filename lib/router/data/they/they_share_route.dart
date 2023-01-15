part of '../app_routes.dart';

@TypedGoRoute<TheyShareRoute>(path: '/they_share/:id')
class TheyShareRoute extends GoRouteData {
  const TheyShareRoute({
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TheyShareScreen(userId: id);
}
