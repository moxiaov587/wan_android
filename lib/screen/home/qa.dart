part of 'home_screen.dart';

class _QA extends ConsumerStatefulWidget {
  const _QA();

  @override
  ConsumerState<_QA> createState() => _QAState();
}

class _QAState extends ConsumerState<_QA>
    with
        AutomaticKeepAliveClientMixin,
        RefreshListViewStateMixin<
            StateNotifierProvider<QuestionNotifier,
                RefreshListViewState<ArticleModel>>,
            ArticleModel,
            _QA> {
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
                                key: Key('qa_article_${article.id}'),
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

  @override
  bool get wantKeepAlive => true;

  @override
  StateNotifierProvider<QuestionNotifier, RefreshListViewState<ArticleModel>>
      get provider => questionArticleProvider;
}
