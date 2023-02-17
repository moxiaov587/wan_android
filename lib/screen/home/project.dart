part of 'home_screen.dart';

class _Project extends ConsumerStatefulWidget {
  const _Project();

  @override
  ConsumerState<_Project> createState() => _ProjectState();
}

class _ProjectState extends ConsumerState<_Project>
    with
        AutomaticKeepAliveClientMixin,
        AutoDisposeRefreshListViewStateMixin<
            AutoDisposeStateNotifierProvider<ProjectNotifier,
                RefreshListViewState<ArticleModel>>,
            ArticleModel,
            _Project> {
  @override
  void onRetry() {
    if (ref.read(projectTypeProvider).hasError) {
      ref.invalidate(projectTypeProvider);
    } else {
      super.onRetry();
    }
  }

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
          child: Consumer(
            builder: (_, WidgetRef ref, __) {
              return NotificationListener<ScrollNotification>(
                onNotification: onScrollNotification,
                child: CustomScrollView(
                  slivers: <Widget>[
                    pullDownIndicator,
                    SliverPinnedPersistentHeader(
                      delegate: _ProjectTypeSwitchSliverHeaderDelegate(
                        extentProtoType:
                            const _ProjectTypeSwitchExtentProtoType(),
                      ),
                    ),
                    Consumer(
                      builder: (_, WidgetRef ref, __) =>
                          ref.watch(provider).when(
                        (
                          int nextPageNum,
                          bool isLastPage,
                          List<ArticleModel> list,
                        ) {
                          if (list.isEmpty) {
                            return const SliverFillRemaining(
                              child: EmptyWidget(),
                            );
                          }

                          return LoadMoreSliverList.separator(
                            loadMoreIndicatorBuilder: loadMoreIndicatorBuilder,
                            itemBuilder: (_, int index) {
                              final ArticleModel article = list[index];

                              return ArticleTile(
                                key: Key('project_article_${article.id}'),
                                article: article,
                              );
                            },
                            separatorBuilder: (_, __) => const IndentDivider(),
                            itemCount: list.length,
                          );
                        },
                        loading: loadingIndicatorBuilder,
                        error: errorIndicatorBuilder,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  AutoDisposeStateNotifierProvider<ProjectNotifier,
          RefreshListViewState<ArticleModel>>
      get provider => projectArticleProvider;
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
                      data: (ProjectTypeModel value) => () {
                        const ProjectTypeRoute().push(context);
                      },
                      loading: () => null,
                      error: (_, __) => () {
                        ref.invalidate(projectTypeProvider);
                      },
                    ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: ref.watch(currentProjectTypeProvider).when(
                        data: (ProjectTypeModel value) => <Widget>[
                          Text(value.name),
                        ],
                        loading: () => const <Widget>[
                          LoadingWidget(
                            radius: 5.0,
                          ),
                        ],
                        error: (_, __) => <Widget>[
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
