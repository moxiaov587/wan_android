import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart' show NavigatorObserver;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Reader;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../contacts/instances.dart';
import '../screen/authorized/provider/authorized_provider.dart';
import '../screen/splash_provider.dart';
import 'locations.dart';
import 'route_name.dart';

class AppRouterDelegate {
  factory AppRouterDelegate() => instance;

  AppRouterDelegate._internal();

  static AppRouterDelegate? _instance;

  static AppRouterDelegate get instance =>
      _instance ??= AppRouterDelegate._internal();

  late final BeamerDelegate _delegate;

  BeamerDelegate get delegate => _delegate;

  HomeState get currentBeamState =>
      _delegate.currentBeamLocation.state as HomeState;

  void initDelegate({
    required Reader reader,
  }) {
    _delegate = _crateDelegate(reader);
  }

  BeamerDelegate _crateDelegate(Reader reader) => BeamerDelegate(
        initialPath: RouterName.home.location,
        notFoundRedirectNamed: RouterName.unknown.location,
        navigatorObservers: <NavigatorObserver>[
          FlutterSmartDialog.observer,
          Instances.routeObserver,
        ],
        locationBuilder: BeamerLocationBuilder(
          beamLocations: <BeamLocation<RouteInformationSerializable<dynamic>>>[
            HomeLocation(),
          ],
        ),
        guards: <BeamGuard>[
          BeamGuard(
            guardNonMatching: true,
            pathPatterns: <Pattern>[RouterName.splash.location],
            check: (_, __) => reader.call(splashProvider),
            beamTo: (
              _,
              __,
              BeamLocation<RouteInformationSerializable<dynamic>> target,
            ) =>
                (target as HomeLocation)
                  ..state.updateWith(
                    showSplash: true,
                    rebuild: false,
                  ),
          ),
          BeamGuard(
            pathPatterns: <Pattern>[
              ...RouterName.homeDrawerPath,
            ],
            check: (_, __) => reader.call(authorizedProvider) != null,
            beamTo: (
              _,
              __,
              BeamLocation<RouteInformationSerializable<dynamic>> target,
            ) =>
                (target as HomeLocation)
                  ..state.updateWith(
                    isLogin: true,
                    isAbout: false,
                    isMyCollections: false,
                    isMyPoints: false,
                    isMyShare: false,
                    rebuild: false,
                  ),
          ),
        ],
      );
}
