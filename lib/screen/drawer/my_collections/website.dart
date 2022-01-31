part of 'my_collections.dart';

class _Website extends StatefulWidget {
  const _Website({Key? key}) : super(key: key);

  @override
  __WebsiteState createState() => __WebsiteState();
}

class __WebsiteState extends State<_Website>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
      builder: (_, __, List<CollectedWebsiteModel> list) {
        return SliverList(
          delegate: CustomSliverChildBuilderDelegate.separated(
            itemBuilder: (_, int index) {
              return _CollectedWebsiteTile(
                key: ValueKey<int>(list[index].id),
                index: index,
              );
            },
            itemCount: list.length,
          ),
        );
      },
    );
  }
}

class _CollectedWebsiteTile extends ConsumerWidget {
  const _CollectedWebsiteTile({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CollectedWebsiteModel? website = ref
        .read(myCollectedWebsiteProvider)
        .whenOrNull<CollectedWebsiteModel?>(
            (List<CollectedWebsiteModel> list) => list.asMap()[index]);

    final bool collected = ref.watch(myCollectedWebsiteProvider.select(
        (ListViewState<CollectedWebsiteModel> value) =>
            value.whenOrNull((List<CollectedWebsiteModel> list) =>
                list.asMap()[index]?.collect ?? false) ??
            true));

    return website != null && collected
        ? Slidable(
            key: key,
            endActionPane: ActionPane(
              extentRatio: .25,
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                closeOnCancel: true,
                dismissThreshold: .65,
                dismissalDuration: const Duration(milliseconds: 500),
                onDismissed: () {
                  ref.read(myCollectedWebsiteProvider.notifier).switchCollected(
                        website.id,
                        collected: false,
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
                  slidableExtentRatio: .25,
                  dismissiblePaneThreshold: .65,
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
                        website.name ?? '',
                        style: currentTheme.textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
