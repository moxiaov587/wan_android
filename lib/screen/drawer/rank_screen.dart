part of 'home_drawer.dart';

const double _kCurrentUserRankTileHeight = 56.0;

class RankScreen extends ConsumerStatefulWidget {
  const RankScreen({super.key});

  @override
  ConsumerState<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends ConsumerState<RankScreen>
    with
        AutoDisposeRefreshListViewStateMixin<
            AutoDisposeStateNotifierProvider<PointsRankNotifier,
                RefreshListViewState<UserPointsModel>>,
            UserPointsModel,
            RankScreen> {
  @override
  Widget build(BuildContext context) {
    final double paddingBottom =
        _kCurrentUserRankTileHeight + ScreenUtils.bottomSafeHeight;

    final UserPointsModel? currentUserPoints =
        ref.read(authorizedProvider)?.userPoints;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).pointsRank),
      ),
      body: Stack(
        children: <Widget>[
          Consumer(
            builder: (_, WidgetRef ref, __) {
              return NotificationListener<ScrollNotification>(
                onNotification: onScrollNotification,
                child: CustomScrollView(
                  slivers: <Widget>[
                    pullDownIndicator,
                    Consumer(
                      builder: (_, WidgetRef ref, __) =>
                          ref.watch(provider).when(
                        (
                          int nextPageNum,
                          bool isLastPage,
                          List<UserPointsModel> list,
                        ) {
                          if (list.isEmpty) {
                            return const SliverFillRemaining(
                              child: EmptyWidget(),
                            );
                          }

                          return SliverPadding(
                            padding: EdgeInsets.only(
                              bottom: currentUserPoints != null
                                  ? paddingBottom
                                  : ScreenUtils.bottomSafeHeight,
                            ),
                            sliver: LoadMoreSliverList.separator(
                              loadMoreIndicatorBuilder:
                                  loadMoreIndicatorBuilder,
                              itemBuilder: (_, int index) {
                                final UserPointsModel points = list[index];

                                return Material(
                                  key: Key('rank_${points.userId}'),
                                  child: Padding(
                                    padding: const EdgeInsets.all(kStyleUint4),
                                    child: _RankTile(
                                      rank: points.rank,
                                      level: points.level,
                                      nickname: points.nickname.strictValue ??
                                          points.username.strictValue ??
                                          '',
                                      totalPoints: points.coinCount,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  const IndentDivider(),
                              itemCount: list.length,
                            ),
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
          if (currentUserPoints != null)
            Positioned(
              left: 0.0,
              bottom: 0.0,
              child: Consumer(
                builder: (_, WidgetRef ref, Widget? empty) {
                  final bool showUserRank = ref.watch(
                    pointsRankProvider.select(
                      (RefreshListViewState<UserPointsModel> vm) =>
                          vm.whenOrNull((_, __, ___) => true) ?? false,
                    ),
                  );

                  final String? fullName =
                      ref.read(authorizedProvider)?.user.nickname;

                  return showUserRank
                      ? Container(
                          width: ScreenUtils.width,
                          height: paddingBottom,
                          padding: EdgeInsets.fromLTRB(
                            kStyleUint4,
                            kStyleUint4,
                            kStyleUint4,
                            kStyleUint4 + ScreenUtils.bottomSafeHeight,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              top: Divider.createBorderSide(context),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: context.theme.colorScheme.background,
                                blurRadius: _kCurrentUserRankTileHeight / 2,
                                blurStyle: BlurStyle.inner,
                              ),
                            ],
                          ),
                          child: _RankTile(
                            key: Key(
                              'rank_tile_${currentUserPoints.userId}',
                            ),
                            rank: currentUserPoints.rank,
                            nickname: fullName.strictValue ??
                                currentUserPoints.nickname.strictValue ??
                                currentUserPoints.username.strictValue,
                            level: currentUserPoints.level,
                            totalPoints: currentUserPoints.coinCount,
                          ),
                        )
                      : empty!;
                },
                child: const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  AutoDisposeStateNotifierProvider<PointsRankNotifier,
      RefreshListViewState<UserPointsModel>> get provider => pointsRankProvider;
}

class _RankTile extends StatelessWidget {
  const _RankTile({
    super.key,
    required this.rank,
    required this.nickname,
    required this.level,
    required this.totalPoints,
  });

  final String? rank;
  final String? nickname;
  final int level;
  final int totalPoints;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          rank ?? '',
          style: context.theme.textTheme.titleLarge,
        ),
        Gap(
          direction: GapDirection.horizontal,
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  nickname.strictValue ?? '',
                  style: context.theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap(
                direction: GapDirection.horizontal,
              ),
              LevelTag(
                level: level,
              ),
            ],
          ),
        ),
        Gap(
          direction: GapDirection.horizontal,
        ),
        Text(
          '$totalPoints',
          style: context.theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
