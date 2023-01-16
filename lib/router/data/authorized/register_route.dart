part of '../app_routes.dart';

@TypedGoRoute<RegisterRoute>(path: '/register')
class RegisterRoute extends GoRouteData {
  const RegisterRoute({this.fromLogin});

  final bool? fromLogin;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RegisterScreen(fromLogin: fromLogin ?? false);
}
