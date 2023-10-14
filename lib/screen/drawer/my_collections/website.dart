part of 'my_collections_screen.dart';

class _Website extends ConsumerStatefulWidget {
  const _Website();

  @override
  __WebsiteState createState() => __WebsiteState();
}

class __WebsiteState extends ConsumerState<_Website>
    with
        AutomaticKeepAliveClientMixin,
        ListViewStateMixin<MyCollectedWebsiteProvider, CollectedWebsiteModel,
            _Website> {
  @override
  bool get wantKeepAlive => true;

  @override
  MyCollectedWebsiteProvider get provider => myCollectedWebsiteProvider;

  @override
  Refreshable<Future<List<CollectedWebsiteModel>>> get refreshable =>
      provider.future;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScrollView(
      slivers: <Widget>[
        pullDownIndicator,
        Consumer(
          builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                data: (List<CollectedWebsiteModel> list) {
                  list = list
                      .where((CollectedWebsiteModel article) => article.collect)
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
                          final CollectedWebsiteModel website = list[index];

                          return SlidableTile.collectedWebsite(
                            key: Key('my_collections_website_${website.id}'),
                            collectedWebsite: website,
                            onDismissed: () {
                              ref
                                  .read(myCollectedWebsiteProvider.notifier)
                                  .switchCollect(
                                    index,
                                    changedValue: false,
                                    triggerCompleteCallback: true,
                                  );
                            },
                            confirmCallback: () async {
                              final bool result = await ref
                                  .read(myCollectedWebsiteProvider.notifier)
                                  .requestCancelCollect(
                                    collectId: website.id,
                                  );

                              return result;
                            },
                            onTap: () async {
                              await ArticleRouteData(id: website.id)
                                  .push<void>(context);

                              ref
                                  .read(provider.notifier)
                                  .onSwitchCollectComplete();
                            },
                            onEditTap: () {
                              unawaited(
                                EditCollectedArticleOrWebsiteRouteData(
                                  type: CollectionType.website,
                                  id: website.id,
                                ).push(context),
                              );
                            },
                          );
                        },
                        findChildIndexCallback: (Key key) {
                          final int index = list.indexWhere(
                            (CollectedWebsiteModel website) =>
                                key ==
                                Key('my_collections_website_${website.id}'),
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
      ],
    );
  }
}
