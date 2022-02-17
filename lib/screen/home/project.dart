part of 'home.dart';

class _Project extends StatefulWidget {
  const _Project({Key? key}) : super(key: key);

  @override
  State<_Project> createState() => _ProjectState();
}

class _ProjectState extends State<_Project> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: <Widget>[
        AppBar(
          leading: const SizedBox.shrink(),
          leadingWidth: 0.0,
          title: Text(S.of(context).project),
        ),
        Expanded(
          child: RefreshListViewWidget<
              StateNotifierProvider<ProjectNotifier,
                  RefreshListViewState<ArticleModel>>,
              ArticleModel>(
            provider: projectArticleProvider,
            onInitState: (Reader reader) {
              reader.call(projectTypesProvider.notifier).initData();
            },
            builder: (_, __, List<ArticleModel> list) {
              return SliverList(
                delegate: CustomSliverChildBuilderDelegate.separated(
                  itemBuilder: (_, int index) {
                    return ArticleTile(
                      article: list[index],
                    );
                  },
                  itemCount: list.length,
                ),
              );
            },
            slivers: <Widget>[
              SliverPinnedPersistentHeader(
                delegate:
                    _ProjectTypeSwitchSliverPinnedPersistentHeaderDelegate(
                  extentProtoType: const _ProjectTypeSwitchExtentProtoType(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProjectTypeSwitchExtentProtoType extends ConsumerWidget {
  const _ProjectTypeSwitchExtentProtoType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: AppTheme.bodyPadding,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Consumer(
            builder: (_, WidgetRef ref, __) {
              return CapsuleInk(
                color: theme.cardColor,
                onTap: ref.watch(currentProjectTypeProvider).when(
                      (ProjectTypeModel? value) => () {
                        AppRouterDelegate.instance.currentBeamState.updateWith(
                          showProjectTypeBottomSheet: true,
                        );
                      },
                      loading: () => null,
                      error: (_, __, ___) => () {
                        ref.read(projectTypesProvider.notifier).refresh();
                      },
                    ),
                child: ref.watch(currentProjectTypeProvider).when(
                      (ProjectTypeModel? value) => Text(value!.name),
                      loading: () => const LoadingWidget(
                        radius: 5.0,
                      ),
                      error: (_, __, ___) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            IconFontIcons.refreshLine,
                            size: 14.0,
                          ),
                          Gap(
                            direction: GapDirection.horizontal,
                            size: GapSize.small,
                          ),
                          Text(S.of(context).retry),
                        ],
                      ),
                    ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProjectTypeSwitchSliverPinnedPersistentHeaderDelegate
    extends SliverPinnedPersistentHeaderDelegate {
  _ProjectTypeSwitchSliverPinnedPersistentHeaderDelegate({
    required Widget extentProtoType,
  }) : super(
          minExtentProtoType: extentProtoType,
          maxExtentProtoType: extentProtoType,
        );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    double? minExtent,
    double maxExtent,
    bool overlapsContent,
  ) {
    return minExtentProtoType;
  }

  @override
  bool shouldRebuild(
          covariant SliverPinnedPersistentHeaderDelegate oldDelegate) =>
      false;
}

class ProjectTypeBottomSheet extends StatelessWidget {
  const ProjectTypeBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: currentTheme.cardColor,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                S.of(context).projectType,
                textAlign: TextAlign.center,
                style: currentTheme.textTheme.titleLarge,
              ),
            ),
            const Divider(),
            Expanded(
              child: ListViewWidget<
                  StateNotifierProvider<ProjectTypeNotifier,
                      ListViewState<ProjectTypeModel>>,
                  ProjectTypeModel>(
                provider: projectTypesProvider,
                builder: (_, __, List<ProjectTypeModel> list) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, int index) {
                        return Consumer(
                          builder: (_, WidgetRef ref, __) {
                            final bool selected = ref.watch(
                                projectTypesProvider.select(
                                    (ListViewState<ProjectTypeModel> value) =>
                                        value.whenOrNull(
                                            (List<ProjectTypeModel> list) =>
                                                list[index].isSelected) ??
                                        false));

                            return ListTile(
                              selected: selected,
                              title: Text(list[index].name),
                              onTap: () {
                                ref
                                    .read(projectTypesProvider.notifier)
                                    .selected(index);

                                Navigator.of(context).maybePop();
                              },
                            );
                          },
                        );
                      },
                      childCount: list.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
