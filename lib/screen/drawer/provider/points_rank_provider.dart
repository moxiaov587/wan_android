part of 'drawer_provider.dart';

@riverpod
class PointsRank extends _$PointsRank with LoadMoreMixin<UserPointsModel> {
  late Http _http;

  @override
  Future<PaginationData<UserPointsModel>> build({
    int pageNum = kDefaultPageNum,
    int pageSize = kDefaultPageSize,
  }) {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    return _http.fetchPointsRank(
      pageNum,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<UserPointsModel>> buildMore(
    int pageNum,
    int pageSize,
  ) =>
      build(pageNum: pageNum, pageSize: pageSize);
}
