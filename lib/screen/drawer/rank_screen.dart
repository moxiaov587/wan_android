part of 'home_drawer.dart';

const double _kCurrentUserRankTileHeight = 56.0;

class RankScreen extends ConsumerStatefulWidget {
  const RankScreen({super.key});

  @override
  ConsumerState<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends ConsumerState<RankScreen>
    with
        RefreshListViewStateMixin<PointsRankProvider, UserPointsModel,
            RankScreen> {
  @override
  PointsRankProvider get provider => pointsRankProvider();

  @override
  PaginationDataRefreshable<UserPointsModel> get refreshable => provider.future;

  @override
  Future<LoadingMoreStatus?> loadMore() =>
      ref.read(provider.notifier).loadMore();

  @override
  Widget build(BuildContext context) {
    final double paddingBottom =
        _kCurrentUserRankTileHeight + ScreenUtils.bottomSafeHeight;

    final UserPointsModel? currentUserPoints =
        ref.read(authorizedProvider).valueOrNull?.userPoints;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).pointsRank),
      ),
      body: Stack(
        children: <Widget>[
          NotificationListener<ScrollNotification>(
            onNotification: onScrollNotification,
            child: CustomScrollView(
              slivers: <Widget>[
                pullDownIndicator,
                Consumer(
                  builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                        data: (PaginationData<UserPointsModel> data) {
                          final List<UserPointsModel> list = data.datas;

                          if (list.isEmpty) {
                            return const SliverFillRemaining(
                              child: EmptyWidget(),
                            );
                          }

                          return SliverPrototypeExtentList(
                            delegate: SliverChildBuilderDelegate(
                              (_, int index) {
                                final UserPointsModel points = list[index];

                                return _RankTile(
                                  key: Key('rank_${points.userId}'),
                                  rank: points.rank,
                                  level: points.level,
                                  nickname: points.nickname.strictValue ??
                                      points.username.strictValue ??
                                      '',
                                  totalPoints: points.coinCount,
                                );
                              },
                              childCount: list.length,
                            ),
                            prototypeItem: const _RankTile.prototypeItem(),
                          );
                        },
                        loading: loadingIndicatorBuilder,
                        error: errorIndicatorBuilder,
                      ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: currentUserPoints != null
                        ? paddingBottom
                        : ScreenUtils.bottomSafeHeight,
                  ),
                  sliver: loadMoreIndicator,
                ),
              ],
            ),
          ),
          if (currentUserPoints != null)
            Positioned(
              left: 0.0,
              bottom: 0.0,
              child: Consumer(
                builder: (_, WidgetRef ref, __) {
                  final bool showUserRank = ref.watch(
                    provider.select(
                      (AsyncValue<PaginationData<UserPointsModel>> vm) =>
                          vm.whenOrNull(
                            data: (_) => true,
                          ) ??
                          false,
                    ),
                  );

                  final String? fullName =
                      ref.read(authorizedProvider).valueOrNull?.user.nickname;

                  return showUserRank
                      ? SizedBox.fromSize(
                          size: Size(ScreenUtils.width, paddingBottom),
                          child: _RankTile(
                            key: Key('rank_tile_${currentUserPoints.userId}'),
                            rank: currentUserPoints.rank,
                            nickname: fullName.strictValue ??
                                currentUserPoints.nickname.strictValue ??
                                currentUserPoints.username.strictValue,
                            level: currentUserPoints.level,
                            totalPoints: currentUserPoints.coinCount,
                            isSelf: true,
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _RankTile extends StatelessWidget {
  const _RankTile({
    required this.rank,
    required this.nickname,
    required this.level,
    required this.totalPoints,
    super.key,
    this.isSelf = false,
  });

  const _RankTile.prototypeItem()
      : rank = '1',
        nickname = 'PROTOTYPE_ITEM',
        level = 1000,
        totalPoints = 100,
        isSelf = false;

  final String? rank;
  final String? nickname;
  final int level;
  final int totalPoints;
  final bool isSelf;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: isSelf ? null : context.theme.colorScheme.background,
          border: Border(
            top: isSelf ? Divider.createBorderSide(context) : BorderSide.none,
            bottom:
                isSelf ? BorderSide.none : Divider.createBorderSide(context),
          ),
          boxShadow: isSelf
              ? <BoxShadow>[
                  BoxShadow(
                    color: context.theme.colorScheme.background,
                    blurRadius: _kCurrentUserRankTileHeight / 2,
                    blurStyle: BlurStyle.inner,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(kStyleUint4).copyWith(
            bottom: isSelf ? kStyleUint4 + ScreenUtils.bottomSafeHeight : null,
          ),
          child: Row(
            children: <Widget>[
              Text(
                rank ?? '',
                style: context.theme.textTheme.titleLarge,
              ),
              const Gap.hn(),
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
                    const Gap.hn(),
                    LevelTag(level: level),
                  ],
                ),
              ),
              const Gap.hn(),
              Text(
                totalPoints.toString(),
                style: context.theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
}
