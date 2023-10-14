part of 'app_route_datas.dart';

@TypedGoRoute<SearchRouteData>(path: '/search')
class SearchRouteData extends GoRouteData {
  const SearchRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      AppPage<void>.routeBuilder(
        routeBuilder: (BuildContext context, RouteSettings settings) =>
            SearchPageRoute<void>(
          delegate: HomeSearchDelegate(),
          settings: settings,
        ),
      );
}

@TypedGoRoute<ArticleRouteData>(path: '/article/:id')
class ArticleRouteData extends GoRouteData {
  const ArticleRouteData({required this.id});

  final int id;

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ArticleScreen(id: id);
}

@TypedGoRoute<TheyArticlesRouteData>(path: '/:author/articles')
class TheyArticlesRouteData extends GoRouteData {
  const TheyArticlesRouteData({
    required this.author,
  });

  final String author;

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TheyArticlesScreen(author: author);
}

@TypedGoRoute<TheyShareRouteData>(path: '/:id/share')
class TheyShareRouteData extends GoRouteData {
  const TheyShareRouteData({
    required this.id,
  });

  final int id;

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TheyShareScreen(userId: id);
}

class UnknownRouteData extends GoRouteData {
  const UnknownRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      Instances.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UnknownScreen(state: state);
}
