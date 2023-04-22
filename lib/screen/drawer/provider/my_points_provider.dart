part of 'drawer_provider.dart';

@riverpod
class MyPoints extends _$MyPoints with LoadMoreMixin<PointsModel> {
  late Http _http;

  @override
  Future<PaginationData<PointsModel>> build({
    int pageNum = kDefaultPageNum,
    int pageSize = kDefaultPageSize,
  }) {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    return _http.fetchUserPointsRecord(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<PointsModel>> buildMore(int pageNum, int pageSize) =>
      build(pageNum: pageNum, pageSize: pageSize);
}
