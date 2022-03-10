part of 'my_collections_screen.dart';

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
      builder: (_, WidgetRef ref, List<CollectedWebsiteModel> list) {
        return SliverList(
          delegate: CustomSliverChildBuilderDelegate.separated(
            itemBuilder: (_, int index) {
              return ProviderScope(
                overrides: <Override>[
                  _currentWebsiteProvider.overrideWithValue(
                    ref.watch(myCollectedWebsiteProvider).whenOrNull(
                          (List<CollectedWebsiteModel> list) => list[index],
                        ),
                  ),
                ],
                child: _CollectedWebsiteTile(
                  key: ValueKey<int>(list[index].id),
                ),
              );
            },
            itemCount: list.length,
          ),
        );
      },
    );
  }
}

final AutoDisposeProvider<CollectedWebsiteModel?> _currentWebsiteProvider =
    Provider.autoDispose<CollectedWebsiteModel?>(
  (_) => null,
);

class _CollectedWebsiteTile extends ConsumerWidget {
  const _CollectedWebsiteTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CollectedWebsiteModel? website = ref.read(_currentWebsiteProvider);

    return website != null && website.collect
        ? Slidable(
            key: key,
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
                        HTMLParseUtils.parseArticleTitle(title: website.name) ??
                            S.of(context).unknown,
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
