part of '../locations.dart';

class UnknownState extends ChangeNotifier
    with RouteInformationSerializable<UnknownState> {
  @override
  UnknownState fromRouteInformation(RouteInformation routeInformation) => this;

  @override
  RouteInformation toRouteInformation() {
    return RouteInformation(
      location: RouterName.unknown.location,
    );
  }
}
