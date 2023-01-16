part of '../app_routes.dart';

@TypedGoRoute<AboutRoute>(path: '/about')
class AboutRoute extends GoRouteData {
  const AboutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AboutScreen();
}
