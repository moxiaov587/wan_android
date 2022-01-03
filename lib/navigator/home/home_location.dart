part of '../locations.dart';

class HomeLocation extends BeamLocation<HomeState> {
  @override
  HomeState createState(RouteInformation routeInformation) =>
      HomeState().fromRouteInformation(routeInformation);

  @override
  void initState() {
    super.initState();
    state.addListener(notifyListeners);
  }

  @override
  void updateState(RouteInformation routeInformation) {
    final HomeState homeState =
        HomeState().fromRouteInformation(routeInformation);
    LogUtils.d('$runtimeType update state: path = ${homeState.initialPath}');

    state.updateWith(
      initialPath: homeState.initialPath,
      showProjectTypeBottomSheet: homeState.showProjectTypeBottomSheet,
      showSearch: homeState.showSearch,
      isLogin: homeState.isLogin,
      isRegister: homeState.isRegister,
      isAbout: homeState.isAbout,
      isMyCollections: homeState.isMyCollections,
      isMyPoints: homeState.isMyPoints,
      isMyShare: homeState.isMyShare,
      showSplash: homeState.showSplash,
      isUnknown: homeState.isUnknown,
    );
  }

  @override
  void disposeState() {
    state.removeListener(notifyListeners);
    super.disposeState();
  }

  @override
  List<Pattern> get pathPatterns => <Pattern>['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, HomeState state) {
    LogUtils.d('$runtimeType build pages: current path = ${state.initialPath}');

    return state.showSplash
        ? <BeamPage>[
            BeamPage(
              key: ValueKey<String>(RouterName.splash.location),
              title: RouterName.splash.title,
              child: const SplashScreen(),
              onPopPage: (
                _,
                __,
                RouteInformationSerializable<dynamic> state,
                ___,
              ) {
                (state as HomeState).updateWith(
                  isUnknown: false,
                );

                return true;
              },
            ),
          ]
        : <BeamPage>[
            BeamPage(
              key: ValueKey<String>(RouterName.home.location),
              title: RouterName.home.title,
              child: HomeScreen(
                initialPath: state.initialPath,
              ),
            ),
            if (state.showProjectTypeBottomSheet)
              BeamPage(
                key: ValueKey<String>(RouterName.projectType.location),
                title: RouterName.projectType.title,
                routeBuilder: (BuildContext context, RouteSettings settings,
                    Widget child) {
                  const Radius radius = Radius.circular(20);

                  return ModalBottomSheetRoute<void>(
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: radius,
                        topRight: radius,
                      ),
                    ),
                    builder: (_) => child,
                    settings: settings,
                    capturedThemes: InheritedTheme.capture(
                      from: context,
                      to: Beamer.of(context).navigator.context,
                    ),
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                  );
                },
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    showProjectTypeBottomSheet: false,
                  );

                  return true;
                },
                child: const ProjectTypeBottomSheet(),
              ),
            if (state.showSearch)
              BeamPage(
                key: ValueKey<String>(RouterName.search.location),
                title: RouterName.search.title,
                routeBuilder: (_, RouteSettings settings, Widget child) {
                  return SearchPageRoute<void>(
                    delegate: HomeSearchDelegate(),
                    settings: settings,
                  );
                },
                child: const SizedBox.shrink(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    showSearch: false,
                  );

                  return true;
                },
              ),
            if (state.isAbout)
              BeamPage(
                key: ValueKey<String>(RouterName.about.location),
                title: RouterName.about.title,
                child: const AboutScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isAbout: false,
                  );

                  return true;
                },
              ),
            if (state.isMyCollections)
              BeamPage(
                key: ValueKey<String>(RouterName.myCollections.location),
                title: RouterName.myCollections.title,
                child: const MyCollectionsScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isMyCollections: false,
                  );

                  return true;
                },
              ),
            if (state.isMyPoints)
              BeamPage(
                key: ValueKey<String>(RouterName.myPoints.location),
                title: RouterName.myPoints.title,
                child: const MyPointsScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isMyPoints: false,
                  );

                  return true;
                },
              ),
            if (state.isMyShare)
              BeamPage(
                key: ValueKey<String>(RouterName.myShare.location),
                title: RouterName.myShare.title,
                child: const MyShareScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isMyShare: false,
                  );

                  return true;
                },
              ),
            if (state.isLogin)
              BeamPage(
                key: ValueKey<String>(RouterName.login.location),
                title: RouterName.login.title,
                child: const LoginScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isLogin: false,
                  );

                  return true;
                },
              ),
            if (state.isRegister)
              BeamPage(
                key: ValueKey<String>(RouterName.register.location),
                title: RouterName.register.title,
                child: const RegisterScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isRegister: false,
                  );

                  return true;
                },
              ),
            if (state.isUnknown)
              BeamPage(
                key: ValueKey<String>(RouterName.unknown.location),
                title: RouterName.unknown.title,
                child: const UnknownScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isUnknown: false,
                  );

                  return true;
                },
              ),
          ];
  }
}
