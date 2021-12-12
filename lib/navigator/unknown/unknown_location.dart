part of '../locations.dart';

class UnknownLocation extends BeamLocation<UnknownState> {
  @override
  UnknownState createState(RouteInformation routeInformation) =>
      UnknownState().fromRouteInformation(routeInformation);

  @override
  void updateState(RouteInformation routeInformation) {
    LogUtils.d('$runtimeType update state');
  }

  @override
  List<Pattern> get pathPatterns => <Pattern>[
        '/*',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, UnknownState state) {
    LogUtils.d('$runtimeType build pages');
    return <BeamPage>[
      BeamPage(
        key: ValueKey<String>(RouterName.home.title),
        title: RouterName.home.title,
        child: const HomeScreen(
          initialPath: '/',
        ),
      ),
      BeamPage(
        key: ValueKey<String>(RouterName.unknown.title),
        title: RouterName.unknown.title,
        child: const UnknownScreen(),
      ),
    ];
  }
}
