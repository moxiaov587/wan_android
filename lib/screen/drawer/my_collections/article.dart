part of 'my_collections_screen.dart';

class _Article extends ConsumerStatefulWidget {
  const _Article();

  @override
  __ArticleState createState() => __ArticleState();
}

class __ArticleState extends ConsumerState<_Article>
    with
        AutomaticKeepAliveClientMixin,
        RefreshListViewStateMixin<MyCollectedArticleProvider,
            CollectedArticleModel, _Article> {
  @override
  bool get wantKeepAlive => true;

  @override
  MyCollectedArticleProvider get provider => myCollectedArticleProvider();

  @override
  PaginationDataRefreshable<CollectedArticleModel> get refreshable =>
      provider.future;

  @override
  Future<LoadingMoreStatus?> loadMore() =>
      ref.read(provider.notifier).loadMore();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: CustomScrollView(
        slivers: <Widget>[
          pullDownIndicator,
          Consumer(
            builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                  data: (PaginationData<CollectedArticleModel> data) {
                    final List<CollectedArticleModel> list = data.datas
                        .where(
                          (CollectedArticleModel article) => article.collect,
                        )
                        .toList();

                    if (list.isEmpty) {
                      return const SliverFillRemaining(
                        child: EmptyWidget.favorites(),
                      );
                    }

                    return SlidableAutoCloseBehavior(
                      child: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, int index) {
                            final CollectedArticleModel article = list[index];

                            return SlidableTile.collectedArticle(
                              key: Key('my_collections_article_${article.id}'),
                              collectedArticle: article,
                              onDismissed: () {
                                ref.read(provider.notifier).switchCollect(
                                      index,
                                      changedValue: false,
                                      triggerCompleteCallback: true,
                                    );
                              },
                              confirmCallback: () async {
                                final bool result = await ref
                                    .read(provider.notifier)
                                    .requestCancelCollect(
                                      collectId: article.id,
                                      articleId: article.originId,
                                    );

                                return result;
                              },
                              onTap: () async {
                                await ArticleRoute(id: article.id)
                                    .push<void>(context);

                                ref
                                    .read(provider.notifier)
                                    .onSwitchCollectComplete();
                              },
                              onEditTap: () {
                                unawaited(
                                  EditCollectedArticleOrWebsiteRoute(
                                    type: CollectionType.article,
                                    id: article.id,
                                  ).push(context),
                                );
                              },
                            );
                          },
                          findChildIndexCallback: (Key key) {
                            final int index = list.indexWhere(
                              (CollectedArticleModel article) =>
                                  key ==
                                  Key('my_collections_article_${article.id}'),
                            );

                            if (index == -1) {
                              return null;
                            }

                            return index;
                          },
                          childCount: list.length,
                        ),
                      ),
                    );
                  },
                  loading: loadingIndicatorBuilder,
                  error: errorIndicatorBuilder,
                ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: context.mqPadding.bottom),
            sliver: loadMoreIndicator,
          ),
        ],
      ),
    );
  }
}
