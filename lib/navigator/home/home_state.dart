part of '../locations.dart';

class HomeState extends ChangeNotifier
    with RouteInformationSerializable<HomeState> {
  HomeState({
    this.initialPath = '/',
    this.showProjectTypeBottomSheet = false,
    this.showSearch = false,
    this.unknownPath = false,
  });

  final String initialPath;

  final bool showProjectTypeBottomSheet;

  final bool showSearch;

  final bool unknownPath;

  @override
  HomeState fromRouteInformation(RouteInformation routeInformation) {
    final Uri uri = Uri.parse(routeInformation.location ?? '/');

    LogUtils.d('from routeInformation : $uri');

    final String uriString = uri.toString();

    if (RouterName.homeTabsPath.contains(uriString)) {
      return HomeState(initialPath: uriString);
    } else if (RouterName.homePath.contains(uriString)) {
      if (uriString == RouterName.search.location) {
        return HomeState(
          initialPath: uriString,
          showSearch: true,
        );
      } else {
        return HomeState(
          initialPath: uriString,
          showProjectTypeBottomSheet: true,
        );
      }
    } else {
      return HomeState(
        initialPath: RouterName.unknown.location,
        unknownPath: true,
      );
    }
  }

  @override
  RouteInformation toRouteInformation() {
    LogUtils.d('$runtimeType to routeInformation: current path = $initialPath');
    final String location =
        unknownPath ? RouterName.unknown.location : initialPath;
    return RouteInformation(location: location);
  }
}
