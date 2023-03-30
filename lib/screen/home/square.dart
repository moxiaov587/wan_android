part of 'home_screen.dart';

class _Square extends ConsumerStatefulWidget {
  const _Square();

  @override
  ConsumerState<_Square> createState() => _SquareState();
}

class _SquareState extends ConsumerState<_Square>
    with
        AutomaticKeepAliveClientMixin,
        RefreshListViewStateMixin<SquareArticleProvider, ArticleModel,
            _Square> {
  @override
  bool get wantKeepAlive => true;

  @override
  SquareArticleProvider get provider => squareArticleProvider();

  @override
  Refreshable<Future<PaginationData<ArticleModel>>> get refreshable =>
      provider.future;

  @override
  OnLoadMoreCallback get loadMore => ref.read(provider.notifier).loadMore;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: <Widget>[
        AppBar(
          leading: nil,
          leadingWidth: 0.0,
          title: Text(S.of(context).square),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
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
                                  key: Key('square_article_${article.id}'),
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
                loadMoreIndicator,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
