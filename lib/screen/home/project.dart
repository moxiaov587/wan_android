part of 'home_screen.dart';

class _Project extends ConsumerStatefulWidget {
  const _Project();

  @override
  ConsumerState<_Project> createState() => _ProjectState();
}

class _ProjectState extends ConsumerState<_Project>
    with
        AutomaticKeepAliveClientMixin,
        AutoDisposeRefreshListViewStateMixin<ProjectArticleProvider,
            ArticleModel, _Project> {
  @override
  bool get wantKeepAlive => true;

  @override
  ProjectArticleProvider get provider => projectArticleProvider;

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
          child: NotificationListener<ScrollNotification>(
            onNotification: onScrollNotification,
            child: CustomScrollView(
              slivers: <Widget>[
                const _FloatingHeader(),
                pullDownIndicator,
                Consumer(
                  builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                    (_, __, List<ArticleModel> list) {
                      if (list.isEmpty) {
                        return const SliverFillRemaining(child: EmptyWidget());
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
          ),
        ),
      ],
    );
  }
}

class _ProjectTypeSwitch extends StatelessWidget {
  const _ProjectTypeSwitch();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: AppTheme.bodyPaddingOnlyHorizontal,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Consumer(
            builder: (_, WidgetRef ref, __) => CapsuleInk(
              color: context.theme.cardColor,
              onTap: () {
                ref.read(currentProjectTypeProvider).when(
                      data: (ProjectTypeModel value) {
                        const ProjectTypeRoute().push(context);
                      },
                      loading: () {},
                      error: (_, __) {
                        ref.invalidate(projectTypeProvider);
                      },
                    );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: ref.watch(currentProjectTypeProvider).when(
                      data: (ProjectTypeModel value) =>
                          <Widget>[Text(value.name)],
                      loading: () => const <Widget>[LoadingWidget(radius: 5.0)],
                      error: (_, __) => <Widget>[
                        const Icon(IconFontIcons.refreshLine, size: 14.0),
                        const Gap.hs(),
                        Text(S.of(context).retry),
                      ],
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingHeaderSnapDelegate extends SliverPersistentHeaderDelegate {
  const _FloatingHeaderSnapDelegate({
    required this.vsync,
    required this.snapConfiguration,
    required this.showOnScreenConfiguration,
  });

  @override
  final TickerProvider vsync;

  @override
  final FloatingHeaderSnapConfiguration snapConfiguration;

  @override
  final PersistentHeaderShowOnScreenConfiguration showOnScreenConfiguration;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const _ProjectTypeSwitch();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.vsync != vsync ||
      oldDelegate.snapConfiguration != snapConfiguration ||
      oldDelegate.showOnScreenConfiguration != showOnScreenConfiguration;
}

class _FloatingHeader extends StatefulWidget {
  const _FloatingHeader();

  @override
  State<_FloatingHeader> createState() => _FloatingHeaderState();
}

class _FloatingHeaderState extends State<_FloatingHeader>
    with TickerProviderStateMixin {
  late final FloatingHeaderSnapConfiguration _snapConfiguration =
      FloatingHeaderSnapConfiguration(curve: Curves.easeOut);

  late final PersistentHeaderShowOnScreenConfiguration
      _showOnScreenConfiguration =
      const PersistentHeaderShowOnScreenConfiguration();

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _FloatingHeaderSnapDelegate(
        vsync: this,
        snapConfiguration: _snapConfiguration,
        showOnScreenConfiguration: _showOnScreenConfiguration,
      ),
      floating: true,
    );
  }
}
