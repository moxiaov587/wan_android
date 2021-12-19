part of '../locations.dart';

class HomeLocation extends BeamLocation<HomeState> {
  @override
  HomeState createState(RouteInformation routeInformation) =>
      HomeState().fromRouteInformation(routeInformation);

  @override
  void updateState(RouteInformation routeInformation) {
    final HomeState homeState =
        HomeState().fromRouteInformation(routeInformation);
    LogUtils.d('$runtimeType update state: path = ${homeState.initialPath}');
  }

  @override
  List<Pattern> get pathPatterns => <Pattern>[
        ...RouterName.homeTabsPath,
        ...RouterName.homePath,
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, HomeState state) {
    LogUtils.d('$runtimeType build pages: current path = ${state.initialPath}');
    return <BeamPage>[
      BeamPage(
        key: ValueKey<String>(RouterName.home.title),
        title: RouterName.home.title,
        child: HomeScreen(
          initialPath: state.initialPath,
        ),
      ),
      if (state.showProjectTypeBottomSheet)
        BeamPage(
          key: ValueKey<String>(RouterName.projectType.title),
          title: RouterName.projectType.title,
          routeBuilder:
              (BuildContext context, RouteSettings settings, Widget child) {
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
              barrierLabel:
                  MaterialLocalizations.of(context).modalBarrierDismissLabel,
            );
          },
          onPopPage: (_, BeamerDelegate delegate, __, ___) {
            delegate.currentBeamLocation.update(
              (_) => HomeState(
                initialPath: RouterName.project.location,
              ),
            );
            return true;
          },
          child: const ProjectTypeBottomSheet(),
        ),
      if (state.showSearch)
        BeamPage(
          key: ValueKey<String>(RouterName.search.title),
          title: RouterName.search.title,
          routeBuilder: (_, RouteSettings settings, Widget child) {
            return SearchPageRoute<void>(
              delegate: HomeSearchDelegate(),
              settings: settings,
            );
          },
          child: const SizedBox.shrink(),
          onPopPage: (_, BeamerDelegate delegate, __, ___) {
            final Object? data = delegate.currentBeamLocation.data;
            String? location;
            if (data is Map<String, String>) {
              location = data[kSearchOriginParams];
            }

            delegate.currentBeamLocation.update(
              (_) => HomeState(
                initialPath: location ?? RouterName.home.location,
              ),
            );

            return true;
          },
        ),
      if (state.unknownPath)
        BeamPage(
          key: ValueKey<String>(RouterName.unknown.title),
          title: RouterName.unknown.title,
          child: const UnknownScreen(),
        ),
    ];
  }
}
