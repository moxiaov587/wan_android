part of 'home_screen.dart';

class _Project extends StatefulWidget {
  const _Project();

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
          leading: nil,
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
            onRetry: (Reader reader) {
              if (reader.call(projectTypesProvider)
                  is ListViewStateError<ProjectTypeModel>) {
                reader.call(projectTypesProvider.notifier).initData();
              } else {
                reader.call(projectArticleProvider.notifier).initData();
              }
            },
            builder: (_, __, List<ArticleModel> list) {
              return SliverList(
                delegate: CustomSliverChildBuilderDelegate.separated(
                  itemBuilder: (_, int index) {
                    return ArticleTile(
                      key: ValueKey<String>(
                        'project_article_${list[index].id}',
                      ),
                      article: list[index],
                    );
                  },
                  itemCount: list.length,
                ),
              );
            },
            slivers: <Widget>[
              SliverPinnedPersistentHeader(
                delegate: _ProjectTypeSwitchSliverHeaderDelegate(
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
  const _ProjectTypeSwitchExtentProtoType();

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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: ref.watch(currentProjectTypeProvider).when(
                        (ProjectTypeModel? value) => <Widget>[
                          Text(value!.name),
                        ],
                        loading: () => const <Widget>[
                          LoadingWidget(
                            radius: 5.0,
                          ),
                        ],
                        error: (_, __, ___) => <Widget>[
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

class _ProjectTypeSwitchSliverHeaderDelegate
    extends SliverPinnedPersistentHeaderDelegate {
  _ProjectTypeSwitchSliverHeaderDelegate({
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
    covariant SliverPinnedPersistentHeaderDelegate oldDelegate,
  ) =>
      false;
}
