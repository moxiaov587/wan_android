part of 'drawer_provider.dart';

final AutoDisposeStateNotifierProvider<PointsRankNotifier,
        RefreshListViewState<UserPointsModel>> pointsRankProvider =
    StateNotifierProvider.autoDispose<PointsRankNotifier,
        RefreshListViewState<UserPointsModel>>(
  (AutoDisposeStateNotifierProviderRef<PointsRankNotifier,
          RefreshListViewState<UserPointsModel>>
      ref) {
    final CancelToken cancelToken = ref.cancelToken();

    final Http http = ref.watch(networkProvider);

    return PointsRankNotifier(
      const RefreshListViewState<UserPointsModel>.loading(),
      http: http,
      cancelToken: cancelToken,
    )..initData();
  },
);

class PointsRankNotifier extends BaseRefreshListViewNotifier<UserPointsModel> {
  PointsRankNotifier(
    super.state, {
    required this.http,
    this.cancelToken,
  });

  final Http http;

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<UserPointsModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await http.fetchPointsRank(
      pageNum,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }
}
