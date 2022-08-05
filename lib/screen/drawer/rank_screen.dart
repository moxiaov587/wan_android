part of 'home_drawer.dart';

const double _kCurrentUserRankTileHeight = 56.0;

class RankScreen extends ConsumerWidget {
  const RankScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          AutoDisposeRefreshListViewWidget<
              AutoDisposeStateNotifierProvider<PointsRankNotifier,
                  RefreshListViewState<UserPointsModel>>,
              UserPointsModel>(
            provider: pointsRankProvider,
            onInitState: (Reader reader) {
              reader.call(pointsRankProvider.notifier).initData();
            },
            padding: currentUserPoints != null
                ? EdgeInsets.only(bottom: paddingBottom)
                : EdgeInsets.zero,
            itemBuilder: (_, __, ___, UserPointsModel points) {
              return Material(
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
            separatorBuilder: (_, __, ___) => const Divider(),
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
                                color: context.theme.backgroundColor,
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
              Text(
                nickname.strictValue ?? '',
                style: context.theme.textTheme.titleMedium,
              ),
              Gap(
                direction: GapDirection.horizontal,
              ),
              _LevelTag(level: level),
            ],
          ),
        ),
        Text(
          '$totalPoints',
          style: context.theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
