part of 'drawer_provider.dart';

final AutoDisposeStateNotifierProvider<PointsRankNotifier,
        RefreshListViewState<UserPointsModel>> pointsRankProvider =
    StateNotifierProvider.autoDispose<PointsRankNotifier,
        RefreshListViewState<UserPointsModel>>(
  (AutoDisposeStateNotifierProviderRef<PointsRankNotifier,
          RefreshListViewState<UserPointsModel>>
      ref) {
    final CancelToken cancelToken = CancelToken();

    ref.onDispose(() {
      cancelToken.cancel();
    });

    return PointsRankNotifier(
      const RefreshListViewState<UserPointsModel>.loading(),
      cancelToken: cancelToken,
    );
  },
);

class PointsRankNotifier extends BaseRefreshListViewNotifier<UserPointsModel> {
  PointsRankNotifier(
    super.state, {
    this.cancelToken,
  }) : super(
          pageSize: 30,
        );

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<UserPointsModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await WanAndroidAPI.fetchPointsRank(
      pageNum,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }
}
