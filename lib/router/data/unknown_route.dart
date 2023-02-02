part of 'app_routes.dart';

class UnknownRoute extends GoRouteData {
  const UnknownRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UnknownScreen(state: state);
}
