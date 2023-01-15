part of 'app_routes.dart';

@TypedGoRoute<ArticleRoute>(path: '/article/:id')
class ArticleRoute extends GoRouteData {
  const ArticleRoute({required this.id});

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ArticleScreen(id: id);
}
