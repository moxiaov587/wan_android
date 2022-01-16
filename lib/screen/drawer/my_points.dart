part of 'drawer.dart';

class MyPointsScreen extends StatelessWidget {
  const MyPointsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentTheme.appBarTheme.backgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).myPoints),
      ),
      body: SafeArea(
        child: Material(
          color: currentTheme.scaffoldBackgroundColor,
          child: AutoDisposeRefreshListViewWidget<
              AutoDisposeStateNotifierProvider<UserPointsRecordNotifier,
                  RefreshListViewState<PointsModel>>,
              PointsModel>(
            provider: myPointsProvider,
            onInitState: (Reader reader) {
              reader.call(myPointsProvider.notifier).initData();
            },
            builder: (_, __, List<PointsModel> list) {
              return SliverList(
                delegate: CustomSliverChildBuilderDelegate.separated(
                  itemBuilder: (_, int index) {
                    final PointsModel points = list[index];

                    final bool isIncrease = points.coinCount > 0;

                    return ListTile(
                      title: Text(
                        points.desc ?? '',
                      ),
                      trailing: RichText(
                        text: TextSpan(
                          style: currentTheme
                              .textTheme.titleMedium!.semiBoldWeight
                              .copyWith(
                            color: isIncrease
                                ? currentTheme.colorScheme.secondary
                                : currentTheme.errorColor,
                          ),
                          text: isIncrease ? '+' : '-',
                          children: <TextSpan>[
                            TextSpan(
                              text: points.coinCount.toString(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: list.length,
                ),
              );
            },
            slivers: <Widget>[
              SliverPadding(
                key: const ValueKey<String>('total_points_widget'),
                padding: AppTheme.bodyPadding * 2,
                sliver: SliverToBoxAdapter(
                    child: ColoredBox(
                  color: currentTheme.scaffoldBackgroundColor,
                  child: Column(
                    children: <Widget>[
                      Consumer(
                        builder: (_, WidgetRef ref, __) => AnimatedCounter(
                          count: ref
                              .read(authorizedProvider)!
                              .userPoints
                              .coinCount,
                        ),
                      ),
                      Gap(
                        size: GapSize.big,
                      ),
                      Text(
                        S.of(context).totalPoints,
                        style: currentTheme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
