part of 'drawer_provider.dart';

@riverpod
class MyPoints extends _$MyPoints with LoadMoreMixin<PointsModel> {
  late Http http;

  @override
  Future<PaginationData<PointsModel>> build({
    int? pageNum,
    int? pageSize,
  }) {
    final CancelToken cancelToken = ref.cancelToken();

    http = ref.watch(networkProvider);

    return http.fetchUserPointsRecord(
      pageNum ?? initialPageNum,
      pageSize ?? initialPageSize,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<PointsModel>> Function(
    int pageNum,
    int pageSize,
  ) get buildMore => (int pageNum, int pageSize) => build(
        pageNum: pageNum,
        pageSize: pageSize,
      );
}
