part of 'drawer_provider.dart';

typedef MyPointsProvider = AutoDisposeStateNotifierProvider<
    UserPointsRecordNotifier, RefreshListViewState<PointsModel>>;

final MyPointsProvider myPointsProvider = StateNotifierProvider.autoDispose<
    UserPointsRecordNotifier,
    RefreshListViewState<PointsModel>>((AutoDisposeStateNotifierProviderRef<
        UserPointsRecordNotifier, RefreshListViewState<PointsModel>>
    ref) {
  final CancelToken cancelToken = ref.cancelToken();

  final Http http = ref.watch(networkProvider);

  return UserPointsRecordNotifier(
    const RefreshListViewState<PointsModel>.loading(),
    http: http,
    cancelToken: cancelToken,
  )..initData();
});

class UserPointsRecordNotifier
    extends BaseRefreshListViewNotifier<PointsModel> {
  UserPointsRecordNotifier(
    super.state, {
    required this.http,
    this.cancelToken,
  });

  final Http http;

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<PointsModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await http.fetchUserPointsRecord(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }
}
