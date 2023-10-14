part of 'app_route_datas.dart';

@TypedGoRoute<RankRouteData>(path: '/rank')
class RankRouteData extends GoRouteData {
  const RankRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => const RankScreen();
}

@TypedGoRoute<MyPointsRouteData>(path: '/my/points')
class MyPointsRouteData extends GoRouteData {
  const MyPointsRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MyPointsScreen();
}

@TypedGoRoute<MyCollectionsRouteData>(
  path: '/my/collections/:type(article|website)',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<AddCollectedArticleOrWebsiteRouteData>(
      path: 'add',
    ),
    TypedGoRoute<EditCollectedArticleOrWebsiteRouteData>(
      path: 'edit/:id',
    ),
  ],
)
class MyCollectionsRouteData extends GoRouteData {
  const MyCollectionsRouteData({
    required this.type,
  });

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  final CollectionType type;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MyCollectionsScreen(type: type);
}

class AddCollectedArticleOrWebsiteRouteData extends GoRouteData {
  const AddCollectedArticleOrWebsiteRouteData({
    required this.type,
  });

  final CollectionType type;

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      AppModalBottomSheetPage<void>(
        builder: (BuildContext context) => HandleCollectedBottomSheet(
          type: type,
          collectId: null,
        ),
        constraints: BoxConstraints.tightFor(
          height: (context.mqSize.height * 0.85).ceilToDouble(),
        ),
        isScrollControlled: true,
      );
}

class EditCollectedArticleOrWebsiteRouteData extends GoRouteData {
  const EditCollectedArticleOrWebsiteRouteData({
    required this.type,
    required this.id,
  });

  final CollectionType type;

  final int id;

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      AppModalBottomSheetPage<void>(
        builder: (BuildContext context) => HandleCollectedBottomSheet(
          type: type,
          collectId: id,
        ),
        constraints: BoxConstraints.tightFor(
          height: (context.mqSize.height * 0.85).ceilToDouble(),
        ),
        isScrollControlled: true,
      );
}

@TypedGoRoute<MyCollectionsRootRouteData>(path: '/my/collections')
class MyCollectionsRootRouteData extends GoRouteData {
  @override
  String redirect(BuildContext context, GoRouterState state) =>
      const MyCollectionsRouteData(type: CollectionType.article).location;
}

@TypedGoRoute<MyShareRouteData>(
  path: '/my/share',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<HandleSharedBottomSheetRouteData>(path: 'add'),
  ],
)
class MyShareRouteData extends GoRouteData {
  const MyShareRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MyShareScreen();
}

class HandleSharedBottomSheetRouteData extends GoRouteData {
  const HandleSharedBottomSheetRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      AppModalBottomSheetPage<void>(
        builder: (BuildContext context) => const HandleSharedBottomSheet(),
        isScrollControlled: true,
        constraints: BoxConstraints.tightFor(
          height: (context.mqSize.height * 0.8).ceilToDouble(),
        ),
      );
}

@TypedGoRoute<AboutRouteData>(path: '/about')
class AboutRouteData extends GoRouteData {
  const AboutRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AboutScreen();
}

@TypedGoRoute<SettingsRouteData>(
  path: '/settings',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<LanguagesRouteData>(path: 'languages'),
    TypedGoRoute<StorageRouteData>(path: 'storage'),
  ],
)
class SettingsRouteData extends GoRouteData {
  const SettingsRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

class LanguagesRouteData extends GoRouteData {
  const LanguagesRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LanguagesScreen();
}

class StorageRouteData extends GoRouteData {
  const StorageRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StorageScreen();
}
