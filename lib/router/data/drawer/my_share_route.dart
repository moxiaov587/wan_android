part of '../app_routes.dart';

@TypedGoRoute<MyShareRoute>(
  path: '/my/share',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<HandleSharedBottomSheetRoute>(path: 'add'),
  ],
)
class MyShareRoute extends GoRouteData {
  const MyShareRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MyShareScreen();
}

class HandleSharedBottomSheetRoute extends GoRouteData {
  const HandleSharedBottomSheetRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      AppModalBottomSheetPage<void>(
        builder: (_) => const HandleSharedBottomSheet(),
        isScrollControlled: true,
        constraints: BoxConstraints.tightFor(
          height: (ScreenUtils.height * 0.8).ceilToDouble(),
        ),
      );
}
