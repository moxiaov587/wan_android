part of 'they.dart';

class TheyArticlesScreen extends ConsumerStatefulWidget {
  const TheyArticlesScreen({
    required this.author,
    super.key,
  });

  final String author;

  @override
  ConsumerState<TheyArticlesScreen> createState() => _TheyArticlesScreenState();
}

class _TheyArticlesScreenState extends ConsumerState<TheyArticlesScreen>
    with
        RefreshListViewStateMixin<TheyArticleProvider, ArticleModel,
            TheyArticlesScreen> {
  @override
  late final TheyArticleProvider provider = theyArticleProvider(widget.author);

  @override
  Refreshable<Future<PaginationData<ArticleModel>>> get refreshable =>
      provider.future;

  @override
  OnLoadMoreCallback get loadMore => ref.read(provider.notifier).loadMore;

  @override
  Widget build(BuildContext context) => Scaffold(
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
                      data: (PaginationData<ArticleModel> data) {
                        final List<ArticleModel> list = data.datas;

                        if (list.isEmpty) {
                          return const SliverFillRemaining(
                            child: EmptyWidget(),
                          );
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
