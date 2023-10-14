part of 'app_route_datas.dart';

@TypedGoRoute<LoginRouteData>(path: '/login')
class LoginRouteData extends GoRouteData {
  const LoginRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedGoRoute<RegisterRouteData>(path: '/register')
class RegisterRouteData extends GoRouteData {
  const RegisterRouteData({this.fromLogin});

  final bool? fromLogin;

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RegisterScreen(fromLogin: fromLogin ?? false);
}
