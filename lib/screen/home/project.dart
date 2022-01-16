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

class _ProjectTypeSwitchExtentProtoType extends StatelessWidget {
  const _ProjectTypeSwitchExtentProtoType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: currentTheme.scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: AppTheme.bodyPadding,
            child: Ink(
              decoration: BoxDecoration(
                color: currentTheme.cardColor,
                borderRadius: AppTheme.roundedBorderRadius,
              ),
              child: const _ProjectTypeSwitch(),
            ),
          ),
        ],
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

class _ProjectTypeSwitch extends ConsumerWidget {
  const _ProjectTypeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentProjectTypeProvider).when(
          (ProjectTypeModel? value) => CapsuleInk(
            onTap: () {
              AppRouterDelegate.instance.currentBeamState.updateWith(
                showProjectTypeBottomSheet: true,
              );
            },
            child: Text(value!.name),
          ),
          loading: () => const CapsuleInk(
            child: LoadingWidget(
              radius: 5.0,
            ),
          ),
          error: (_, __, ___) => CapsuleInk(
            onTap: () {
              ref.read(projectTypesProvider.notifier).refresh();
            },
            child: Row(
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
  }
}

class ProjectTypeBottomSheet extends StatelessWidget {
  const ProjectTypeBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: currentTheme.cardColor,
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
                      final bool selected =
                          ref.watch(projectTypeIsSelectedProvider(index));

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
    );
  }
}
