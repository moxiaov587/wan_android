part of 'my_collections_screen.dart';

class _Website extends ConsumerStatefulWidget {
  const _Website();

  @override
  __WebsiteState createState() => __WebsiteState();
}

class __WebsiteState extends ConsumerState<_Website>
    with AutomaticKeepAliveClientMixin, RouteAware {
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Instances.routeObserver.subscribe(this, ModalRoute.of<dynamic>(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();

    ref.read(myCollectedWebsiteProvider.notifier).onSwitchCollectComplete();
  }

  @override
  void dispose() {
    Instances.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AutoDisposeListViewWidget<
        AutoDisposeStateNotifierProvider<MyCollectedWebsiteNotifier,
            ListViewState<CollectedWebsiteModel>>,
        CollectedWebsiteModel>(
      provider: myCollectedWebsiteProvider,
      enablePullDown: true,
      onInitState: (Reader reader) {
        reader.call(myCollectedWebsiteProvider.notifier).initData();
      },
      builder: (_, Widget child) => SlidableAutoCloseBehavior(child: child),
      itemBuilder: (_, __, ___, CollectedWebsiteModel website) =>
          website.collect
              ? _CollectedWebsiteTile(
                  key: Key(
                    'my_collections_website_${website.id}',
                  ),
                  website: website,
                )
              : nil,
      separatorBuilder: (_, __, ___) => const Divider(),
    );
  }
}

class _CollectedWebsiteTile extends ConsumerWidget {
  const _CollectedWebsiteTile({super.key, required this.website});

  final CollectedWebsiteModel website;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: key,
      groupTag: CollectionType.website.name,
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
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
          confirmDismiss: () => ref
              .read(myCollectedWebsiteProvider.notifier)
              .requestCancelCollect(
                collectId: website.id,
              ),
        ),
        children: <Widget>[
          DismissibleSlidableAction(
            slidableExtentRatio: 0.25,
            dismissiblePaneThreshold: 0.65,
            label: S.of(context).edit,
            onTap: () {
              AppRouterDelegate.instance.currentBeamState.updateWith(
                showHandleCollectedBottomSheet: true,
                collectionTypeIndex: CollectionType.website.index,
                collectId: website.id,
              );
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
                AppRouterDelegate.instance.currentBeamState.updateWith(
                  articleId: website.id,
                );
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
