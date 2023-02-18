part of 'home_drawer.dart';

class MyPointsScreen extends ConsumerStatefulWidget {
  const MyPointsScreen({super.key});

  @override
  ConsumerState<MyPointsScreen> createState() => _MyPointsScreenState();
}

class _MyPointsScreenState extends ConsumerState<MyPointsScreen>
    with
        AutoDisposeRefreshListViewStateMixin<MyPointsProvider, PointsModel,
            MyPointsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Gap(
                          size: GapSize.big,
                        ),
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
                  (
                    int nextPageNum,
                    bool isLastPage,
                    List<PointsModel> list,
                  ) {
                    if (list.isEmpty) {
                      return const SliverFillRemaining(
                        child: EmptyWidget(),
                      );
                    }

                    return SliverPadding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtils.bottomSafeHeight,
                      ),
                      sliver: LoadMoreSliverList.separator(
                        loadMoreIndicatorBuilder: loadMoreIndicatorBuilder,
                        itemBuilder: (_, int index) {
                          final PointsModel points = list[index];

                          final bool isIncrease = points.coinCount > 0;

                          return ListTile(
                            key: Key('my_points_record_${points.id}'),
                            title: Text(
                              points.desc ?? '',
                            ),
                            trailing: RichText(
                              text: TextSpan(
                                style: context
                                    .theme.textTheme.titleMedium!.semiBold
                                    .copyWith(
                                  color: isIncrease
                                      ? context.theme.colorScheme.secondary
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
                        separatorBuilder: (_, __) =>
                            const IndentDivider.listTile(),
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
        ),
      ),
    );
  }

  @override
  AutoDisposeStateNotifierProvider<UserPointsRecordNotifier,
      RefreshListViewState<PointsModel>> get provider => myPointsProvider;
}
