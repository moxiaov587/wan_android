part of 'app_routes.dart';

@TypedGoRoute<SearchRoute>(path: '/search')
class SearchRoute extends GoRouteData {
  const SearchRoute();

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
