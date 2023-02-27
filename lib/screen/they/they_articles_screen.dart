part of 'they.dart';

class TheyArticlesScreen extends ConsumerStatefulWidget {
  const TheyArticlesScreen({
    super.key,
    required this.author,
  });

  final String author;

  @override
  ConsumerState<TheyArticlesScreen> createState() => _TheyArticlesScreenState();
}

class _TheyArticlesScreenState extends ConsumerState<TheyArticlesScreen>
    with
        AutoDisposeRefreshListViewStateMixin<TheyArticlesProvider, ArticleModel,
            TheyArticlesScreen> {
  @override
  late final TheyArticlesProvider provider =
      theyArticlesProvider(widget.author);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).theyArticles),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: CustomScrollView(
          slivers: <Widget>[
            pullDownIndicator,
            Consumer(
              builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                (_, __, List<ArticleModel> list) {
                  if (list.isEmpty) {
                    return const SliverFillRemaining(child: EmptyWidget());
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, int index) {
                        final ArticleModel article = list[index];

                        return ArticleTile(
                          key: Key('they_article_${article.id}'),
                          authorTextOrShareUserTextCanOnTap: false,
                          article: article,
                        );
                      },
                      childCount: list.length,
                    ),
                  );
                },
                loading: loadingIndicatorBuilder,
                error: errorIndicatorBuilder,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: ScreenUtils.bottomSafeHeight),
              sliver: loadMoreIndicator,
            ),
          ],
        ),
      ),
    );
  }
}
