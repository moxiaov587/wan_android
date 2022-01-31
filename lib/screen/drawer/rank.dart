part of 'drawer.dart';

const double _kCurrentUserRankTileHeight = 56.0;

class RankScreen extends StatelessWidget {
  const RankScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double paddingBottom =
        _kCurrentUserRankTileHeight + ScreenUtils.bottomSafeHeight;

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
            paddingBottom: paddingBottom,
            provider: pointsRankProvider,
            onInitState: (Reader reader) {
              reader.call(pointsRankProvider.notifier).initData();
            },
            builder: (_, WidgetRef ref, List<UserPointsModel> list) {
              return SliverList(
                delegate: CustomSliverChildBuilderDelegate.separated(
                  itemBuilder: (_, int index) {
                    final UserPointsModel points = list[index];

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
                  itemCount: list.length,
                ),
              );
            },
          ),
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? empty) {
                return ref.watch(pointsRankProvider).whenOrNull(
                      (_, __, ___) {
                        final UserPointsModel? points =
                            ref.read(authorizedProvider)?.userPoints;

                        final String? fullName =
                            ref.read(authorizedProvider)?.user.nickname;

                        return points != null
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
                                      color: currentTheme.backgroundColor,
                                      blurRadius:
                                          _kCurrentUserRankTileHeight / 2,
                                      blurStyle: BlurStyle.inner,
                                    ),
                                  ],
                                ),
                                child: _RankTile(
                                  rank: points.rank,
                                  nickname: fullName.strictValue ??
                                      points.nickname.strictValue ??
                                      points.username.strictValue,
                                  level: points.level,
                                  totalPoints: points.coinCount,
                                ),
                              )
                            : empty!;
                      },
                    ) ??
                    empty!;
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
    Key? key,
    required this.rank,
    required this.nickname,
    required this.level,
    required this.totalPoints,
  }) : super(key: key);

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
          style: currentTheme.textTheme.titleLarge,
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
                style: currentTheme.textTheme.titleMedium,
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
          style: currentTheme.textTheme.titleMedium,
        ),
      ],
    );
  }
}