part of '../app_routes.dart';

@TypedGoRoute<MyCollectionsRoute>(
  path: '/my/collections/:type(article|website)',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<AddCollectedArticleOrWebsiteRoute>(
      path: 'add',
    ),
    TypedGoRoute<EditCollectedArticleOrWebsiteRoute>(
      path: 'edit/:id',
    ),
  ],
)
class MyCollectionsRoute extends GoRouteData {
  const MyCollectionsRoute({
    required this.type,
  });

  final CollectionType type;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MyCollectionsScreen(type: type);
}

class AddCollectedArticleOrWebsiteRoute extends GoRouteData {
  const AddCollectedArticleOrWebsiteRoute({
    required this.type,
  });

  final CollectionType type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      AppModalBottomSheetPage<void>(
        builder: (_) => HandleCollectedBottomSheet(
          type: type,
          collectId: null,
        ),
        constraints: BoxConstraints.tightFor(
          height: (ScreenUtils.height * 0.85).ceilToDouble(),
        ),
        isScrollControlled: true,
      );
}

class EditCollectedArticleOrWebsiteRoute extends GoRouteData {
  const EditCollectedArticleOrWebsiteRoute({
    required this.type,
    required this.id,
  });

  final CollectionType type;

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      AppModalBottomSheetPage<void>(
        builder: (_) => HandleCollectedBottomSheet(
          type: type,
          collectId: id,
        ),
        constraints: BoxConstraints.tightFor(
          height: (ScreenUtils.height * 0.85).ceilToDouble(),
        ),
        isScrollControlled: true,
      );
}

@TypedGoRoute<MyCollectionsRootRoute>(path: '/my/collections')
class MyCollectionsRootRoute extends GoRouteData {
  @override
  String redirect(BuildContext context, GoRouterState state) =>
      const MyCollectionsRoute(type: CollectionType.article).location;
}
