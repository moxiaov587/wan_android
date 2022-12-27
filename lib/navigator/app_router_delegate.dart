import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart' show NavigatorObserver;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderContainer;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../contacts/instances.dart';
import '../screen/authorized/provider/authorized_provider.dart';
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
    required ProviderContainer providerContainer,
  }) {
    _delegate = _crateDelegate(providerContainer);
  }

  BeamerDelegate _crateDelegate(ProviderContainer providerContainer) =>
      BeamerDelegate(
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
            pathPatterns: <Pattern>[
              ...RouterName.homeDrawerPath,
            ],
            check: (_, __) =>
                providerContainer.read(authorizedProvider) != null,
            beamTo: (
              _,
              __,
              BeamLocation<RouteInformationSerializable<dynamic>> target,
            ) =>
                (target as HomeLocation)
                  ..state.updateWith(
                    isLogin: true,
                    isMyCollections: false,
                    isMyPoints: false,
                    isMyShare: false,
                  ),
          ),
        ],
      );
}
