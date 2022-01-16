part of 'drawer_provider.dart';

final AutoDisposeStateNotifierProvider<UserPointsRecordNotifier,
        RefreshListViewState<PointsModel>> myPointsProvider =
    StateNotifierProvider.autoDispose<UserPointsRecordNotifier,
        RefreshListViewState<PointsModel>>((AutoDisposeStateNotifierProviderRef<
            UserPointsRecordNotifier, RefreshListViewState<PointsModel>>
        ref) {
  final CancelToken _cancelToken = CancelToken();
  ref.onDispose(() {
    _cancelToken.cancel();
  });

  return UserPointsRecordNotifier(
    const RefreshListViewState<PointsModel>.loading(),
    cancelToken: _cancelToken,
  );
});

class UserPointsRecordNotifier
    extends BaseRefreshListViewNotifier<PointsModel> {
  UserPointsRecordNotifier(
    RefreshListViewState<PointsModel> state, {
    this.cancelToken,
  }) : super(state);

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<PointsModel>> loadData(
      {required int pageNum, required int pageSize}) async {
    return (await WanAndroidAPI.fetchUserPointsRecord(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }
}
