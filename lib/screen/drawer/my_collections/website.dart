part of 'my_collections_screen.dart';

class _Website extends ConsumerStatefulWidget {
  const _Website();

  @override
  __WebsiteState createState() => __WebsiteState();
}

class __WebsiteState extends ConsumerState<_Website>
    with
        AutomaticKeepAliveClientMixin,
        RouteAware,
        AutoDisposeListViewStateMixin<
            AutoDisposeStateNotifierProvider<MyCollectedWebsiteNotifier,
                ListViewState<CollectedWebsiteModel>>,
            CollectedWebsiteModel,
            _Website> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Instances.routeObserver.subscribe(this, ModalRoute.of<dynamic>(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();

    ref.read(provider.notifier).onSwitchCollectComplete();
  }

  @override
  void dispose() {
    Instances.routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScrollView(
      slivers: <Widget>[
        pullDownIndicator,
        Consumer(
          builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
            (List<CollectedWebsiteModel> list) {
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
                  delegate: SliverChildWithSeparatorBuilderDelegate(
                    (_, int index) {
                      final CollectedWebsiteModel website = list[index];

                      return _CollectedWebsiteTile(
                        key: Key('my_collections_website_${website.id}'),
                        website: website,
                      );
                    },
                    findChildIndexCallback: (Key key) {
                      final int index = list.indexWhere(
                        (CollectedWebsiteModel website) =>
                            key == Key('my_collections_website_${website.id}'),
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

  @override
  bool get wantKeepAlive => true;

  @override
  AutoDisposeStateNotifierProvider<MyCollectedWebsiteNotifier,
          ListViewState<CollectedWebsiteModel>>
      get provider => myCollectedWebsiteProvider;
}

class _CollectedWebsiteTile extends ConsumerWidget {
  const _CollectedWebsiteTile({super.key, required this.website});

  final CollectedWebsiteModel website;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: key,
      groupTag: CollectionType.website.name,
      dragStartBehavior: DragStartBehavior.start,
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const StretchMotion(),
        dismissible: DismissiblePane(
          closeOnCancel: true,
          dismissThreshold: 0.65,
          dismissalDuration: const Duration(milliseconds: 500),
          onDismissed: () {
            ref.read(myCollectedWebsiteProvider.notifier).switchCollect(
                  website.id,
                  changedValue: false,
                  triggerCompleteCallback: true,
                );
          },
          confirmDismiss: () async {
            final bool? result = await DialogUtils.confirm<bool>(
              isDanger: true,
              builder: (BuildContext context) {
                return Text(S.of(context).removeWebsiteTips);
              },
              confirmCallback: () async {
                final bool result = await ref
                    .read(myCollectedWebsiteProvider.notifier)
                    .requestCancelCollect(
                      collectId: website.id,
                    );

                return result;
              },
            );

            return result ?? false;
          },
        ),
        children: <Widget>[
          DismissibleSlidableAction(
            slidableExtentRatio: 0.25,
            dismissiblePaneThreshold: 0.65,
            label: S.of(context).edit,
            onTap: () {
              EditCollectedArticleOrWebsiteRoute(
                type: CollectionType.website,
                id: website.id,
              ).push(context);
            },
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: ScreenUtils.width,
          height: 94.0,
        ),
        child: Material(
          child: Ink(
            child: InkWell(
              onTap: () {
                ArticleRoute(id: website.id).push(context);
              },
              child: Padding(
                padding: AppTheme.bodyPadding,
                child: Text(
                  HTMLParseUtils.unescapeHTML(website.name) ??
                      S.of(context).unknown,
                  style: context.theme.textTheme.titleSmall,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
