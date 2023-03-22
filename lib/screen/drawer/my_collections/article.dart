part of 'my_collections_screen.dart';

class _Article extends ConsumerStatefulWidget {
  const _Article();

  @override
  __ArticleState createState() => __ArticleState();
}

class __ArticleState extends ConsumerState<_Article>
    with
        AutomaticKeepAliveClientMixin,
        RouteAware,
        AutoDisposeRefreshListViewStateMixin<MyCollectedArticleProvider,
            CollectedArticleModel, _Article> {
  @override
  bool get wantKeepAlive => true;

  @override
  MyCollectedArticleProvider get provider => myCollectedArticleProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Instances.routeObserver.subscribe(this, ModalRoute.of<dynamic>(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();

    unawaited(
      ref.read(myCollectedArticleProvider.notifier).onSwitchCollectComplete(),
    );
  }

  @override
  void dispose() {
    Instances.routeObserver.unsubscribe(this);

    super.dispose();
  }

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
              (List<CollectedArticleModel> list, _, __) {
                list = list
                    .where((CollectedArticleModel article) => article.collect)
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
                          onDismissed: () async {
                            await ref
                                .read(myCollectedArticleProvider.notifier)
                                .switchCollect(
                                  index,
                                  changedValue: false,
                                  triggerCompleteCallback: true,
                                );
                          },
                          confirmCallback: () async {
                            final bool result = await ref
                                .read(myCollectedArticleProvider.notifier)
                                .requestCancelCollect(
                                  collectId: article.id,
                                  articleId: article.originId,
                                );

                            return result;
                          },
                          onTap: () {
                            ArticleRoute(id: article.id).push(context);
                          },
                          onEditTap: () {
                            EditCollectedArticleOrWebsiteRoute(
                              type: CollectionType.article,
                              id: article.id,
                            ).push(context);
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
            padding: EdgeInsets.only(bottom: ScreenUtils.bottomSafeHeight),
            sliver: loadMoreIndicator,
          ),
        ],
      ),
    );
  }
}
