part of 'drawer_provider.dart';

final AutoDisposeStateNotifierProvider<UserPointsRecordNotifier,
        RefreshListViewState<PointsModel>> myPointsProvider =
    StateNotifierProvider.autoDispose<UserPointsRecordNotifier,
        RefreshListViewState<PointsModel>>((AutoDisposeStateNotifierProviderRef<
            UserPointsRecordNotifier, RefreshListViewState<PointsModel>>
        ref) {
  final CancelToken cancelToken = CancelToken();

  ref.onDispose(() {
    cancelToken.cancel();
  });

  return UserPointsRecordNotifier(
    const RefreshListViewState<PointsModel>.loading(),
    cancelToken: cancelToken,
  );
});

class UserPointsRecordNotifier
    extends BaseRefreshListViewNotifier<PointsModel> {
  UserPointsRecordNotifier(
    super.state, {
    this.cancelToken,
  });

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<PointsModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await WanAndroidAPI.fetchUserPointsRecord(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }
}
