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
      if (state.unknownPath)
        BeamPage(
          key: ValueKey<String>(RouterName.unknown.title),
          title: RouterName.unknown.title,
          child: const UnknownScreen(),
        ),
    ];
  }
}
