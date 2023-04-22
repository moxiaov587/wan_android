part of 'home_screen.dart';

class _QA extends ConsumerStatefulWidget {
  const _QA();

  @override
  ConsumerState<_QA> createState() => _QAState();
}

class _QAState extends ConsumerState<_QA>
    with
        AutomaticKeepAliveClientMixin,
        RefreshListViewStateMixin<QuestionArticleProvider, ArticleModel, _QA> {
  @override
  bool get wantKeepAlive => true;

  @override
  QuestionArticleProvider get provider => questionArticleProvider();

  @override
  PaginationDataRefreshable<ArticleModel> get refreshable => provider.future;

  @override
  Future<LoadingMoreStatus?> loadMore() =>
      ref.read(provider.notifier).loadMore();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: <Widget>[
        AppBar(
          leading: nil,
          leadingWidth: 0.0,
          title: Text(S.of(context).question),
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
                                  key: Key('qa_article_${article.id}'),
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
