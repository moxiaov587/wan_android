part of 'home_drawer.dart';

class MyPointsScreen extends ConsumerStatefulWidget {
  const MyPointsScreen({super.key});

  @override
  ConsumerState<MyPointsScreen> createState() => _MyPointsScreenState();
}

class _MyPointsScreenState extends ConsumerState<MyPointsScreen>
    with
        RefreshListViewStateMixin<MyPointsProvider, PointsModel,
            MyPointsScreen> {
  @override
  MyPointsProvider get provider => myPointsProvider();

  @override
  PaginationDataRefreshable<PointsModel> get refreshable => provider.future;

  @override
  Future<LoadingMoreStatus?> loadMore() =>
      ref.read(provider.notifier).loadMore();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        appBar: AppBar(
          title: Text(S.of(context).myPoints),
        ),
        body: Material(
          color: context.theme.scaffoldBackgroundColor,
          child: NotificationListener<ScrollNotification>(
            onNotification: onScrollNotification,
            child: CustomScrollView(
              slivers: <Widget>[
                pullDownIndicator,
                SliverPadding(
                  padding: AppTheme.bodyPadding * 2,
                  sliver: SliverToBoxAdapter(
                    child: ColoredBox(
                      color: context.theme.scaffoldBackgroundColor,
                      child: Column(
                        children: <Widget>[
                          Consumer(
                            builder: (_, WidgetRef ref, __) => AnimatedCounter(
                              count: ref
                                  .read(authorizedProvider)
                                  .value!
                                  .userPoints
                                  .coinCount,
                            ),
                          ),
                          const Gap.vb(),
                          Text(
                            S.of(context).totalPoints,
                            style: context.theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Consumer(
                  builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                        data: (PaginationData<PointsModel> data) {
                          final List<PointsModel> list = data.datas;

                          if (list.isEmpty) {
                            return const SliverFillRemaining(
                              child: EmptyWidget(),
                            );
                          }

                          return SliverPrototypeExtentList(
                            delegate: SliverChildBuilderDelegate(
                              (_, int index) {
                                final PointsModel points = list[index];

                                final bool isIncrease = points.coinCount > 0;

                                return ListTile(
                                  key: Key('my_points_record_${points.id}'),
                                  title: Text(points.desc ?? ''),
                                  trailing: RichText(
                                    text: TextSpan(
                                      style: context
                                          .theme.textTheme.titleMedium!.semiBold
                                          .copyWith(
                                        color: isIncrease
                                            ? context
                                                .theme.colorScheme.secondary
                                            : context.theme.colorScheme.error,
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
                              childCount: list.length,
                            ),
                            prototypeItem: const ListTile(),
                          );
                        },
                        loading: loadingIndicatorBuilder,
                        error: errorIndicatorBuilder,
                      ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: context.mqPadding.bottom),
                  sliver: loadMoreIndicator,
                ),
              ],
            ),
          ),
        ),
      );
}
