part of 'app_route_datas.dart';

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRouteData>(
          path: '/home',
        ),
      ],
    ),
    TypedStatefulShellBranch<SquareShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<SquareRouteData>(
          path: '/square',
        ),
      ],
    ),
    TypedStatefulShellBranch<QAShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<QARouteData>(
          path: '/qa',
        ),
      ],
    ),
    TypedStatefulShellBranch<ProjectShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProjectRouteData>(
          path: '/project',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<ProjectTypeRouteData>(path: 'type'),
          ],
        ),
      ],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  const MainShellRouteData();

  static final GlobalKey<NavigatorState> $navigatorKey =
      Instances.shellNavigatorKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) =>
      HomeScreen(navigationShell: navigationShell);
}

class HomeShellBranchData extends StatefulShellBranchData {
  const HomeShellBranchData();
}

class SquareShellBranchData extends StatefulShellBranchData {
  const SquareShellBranchData();
}

class QAShellBranchData extends StatefulShellBranchData {
  const QAShellBranchData();
}

class ProjectShellBranchData extends StatefulShellBranchData {
  const ProjectShellBranchData();
}

class HomeRouteData extends GoRouteData {
  const HomeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const Home();
}

class SquareRouteData extends GoRouteData {
  const SquareRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const Square();
}

class QARouteData extends GoRouteData {
  const QARouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const QA();
}

class ProjectRouteData extends GoRouteData {
  const ProjectRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const Project();
}

class ProjectTypeRouteData extends GoRouteData {
  const ProjectTypeRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      AppModalBottomSheetPage<void>(
        builder: (_) => const ProjectTypeBottomSheet(),
      );
}

@TypedGoRoute<RootRouteData>(path: '/')
class RootRouteData extends GoRouteData {
  @override
  String redirect(BuildContext context, GoRouterState state) =>
      const HomeRouteData().location;
}
