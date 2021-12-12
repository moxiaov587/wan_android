part of '../locations.dart';

class HomeState extends ChangeNotifier
    with RouteInformationSerializable<HomeState> {
  HomeState({
    this.initialPath = '/',
    this.unknownPath = false,
  });

  final String initialPath;

  final bool unknownPath;

  @override
  HomeState fromRouteInformation(RouteInformation routeInformation) {
    final Uri uri = Uri.parse(routeInformation.location ?? '/');

    LogUtils.d('from routeInformation : $uri');

    return RouterName.homeTabsPath.contains(uri.toString())
        ? HomeState(initialPath: uri.toString())
        : HomeState(unknownPath: true);
  }

  @override
  RouteInformation toRouteInformation() {
    LogUtils.d('$runtimeType to routeInformation: current path = $initialPath');
    final String location =
        unknownPath ? RouterName.unknown.location : initialPath;
    return RouteInformation(location: location);
  }
}
