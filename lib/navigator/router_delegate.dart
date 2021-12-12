import 'package:beamer/beamer.dart';

import 'locations.dart';

class AppRouterDelegate {
  AppRouterDelegate._();

  static final BeamerDelegate routerDelegate = BeamerDelegate(
    notFoundRedirect: UnknownLocation(),
    locationBuilder: BeamerLocationBuilder(
      beamLocations: <BeamLocation<RouteInformationSerializable<dynamic>>>[
        HomeLocation(),
        UnknownLocation(),
      ],
    ),
  );
}
