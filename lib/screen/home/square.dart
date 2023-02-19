part of 'home_screen.dart';

class _Square extends ConsumerStatefulWidget {
  const _Square();

  @override
  ConsumerState<_Square> createState() => _SquareState();
}

class _SquareState extends ConsumerState<_Square>
    with
        AutomaticKeepAliveClientMixin,
        AutoDisposeRefreshListViewStateMixin<SquareArticleProvider,
            ArticleModel, _Square> {
  @override
  bool get wantKeepAlive => true;

  @override
  SquareArticleProvider get provider => squareArticleProvider;

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
          child: Consumer(
            builder: (_, WidgetRef ref, __) {
              return NotificationListener<ScrollNotification>(
                onNotification: onScrollNotification,
                child: CustomScrollView(
                  slivers: <Widget>[
                    pullDownIndicator,
                    Consumer(
                      builder: (_, WidgetRef ref, __) =>
                          ref.watch(provider).when(
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
                                key: Key('square_article_${article.id}'),
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
      ],
    );
  }
}
