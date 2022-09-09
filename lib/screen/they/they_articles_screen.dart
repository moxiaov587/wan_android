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
        AutoDisposeRefreshListViewStateMixin<
            AutoDisposeStateNotifierProvider<TheyArticlesNotifier,
                RefreshListViewState<ArticleModel>>,
            ArticleModel,
            TheyArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).theyArticles),
      ),
      body: SafeArea(
        child: Consumer(
          builder: (_, WidgetRef ref, __) {
            return NotificationListener<ScrollNotification>(
              onNotification: onScrollNotification,
              child: CustomScrollView(
                slivers: <Widget>[
                  pullDownIndicator,
                  Consumer(
                    builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                      (
                        int nextPageNum,
                        bool isLastPage,
                        List<ArticleModel> list,
                      ) {
                        if (list.isEmpty) {
                          return const SliverFillRemaining(
                            child: EmptyWidget(),
                          );
                        }

                        return LoadMoreSliverList.separator(
                          loadMoreIndicatorBuilder: loadMoreIndicatorBuilder,
                          itemBuilder: (_, int index) {
                            final ArticleModel article = list[index];

                            return ArticleTile(
                              key: Key('they_article_${article.id}'),
                              authorTextOrShareUserTextCanOnTap: false,
                              article: article,
                            );
                          },
                          separatorBuilder: (_, __) => const IndentDivider(),
                          itemCount: list.length,
                        );
                      },
                      loading: loadingIndicatorBuilder,
                      error: errorIndicatorBuilder,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  late final AutoDisposeStateNotifierProvider<TheyArticlesNotifier,
          RefreshListViewState<ArticleModel>> provider =
      theyArticlesProvider(widget.author);
}
