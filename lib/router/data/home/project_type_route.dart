part of '../app_routes.dart';

@TypedGoRoute<ProjectTypeRoute>(path: '/project/type')
class ProjectTypeRoute extends GoRouteData {
  const ProjectTypeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      AppModalBottomSheetPage<void>(
        builder: (_) => const ProjectTypeBottomSheet(),
      );
}
