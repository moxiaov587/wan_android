part of '../app_routes.dart';

@TypedGoRoute<TheyArticlesRoute>(path: '/:author/articles')
class TheyArticlesRoute extends GoRouteData {
  const TheyArticlesRoute({
    required this.author,
  });

  final String author;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TheyArticlesScreen(author: author);
}
