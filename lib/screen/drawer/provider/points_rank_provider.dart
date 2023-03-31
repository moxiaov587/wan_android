part of 'drawer_provider.dart';

@riverpod
class PointsRank extends _$PointsRank with LoadMoreMixin<UserPointsModel> {
  late Http http;

  @override
  Future<PaginationData<UserPointsModel>> build({
    int? pageNum,
    int? pageSize,
  }) {
    final CancelToken cancelToken = ref.cancelToken();

    http = ref.watch(networkProvider);

    return http.fetchPointsRank(
      pageNum ?? initialPageNum,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<UserPointsModel>> Function(
    int pageNum,
    int pageSize,
  ) get buildMore => (int pageNum, int pageSize) => build(
        pageNum: pageNum,
        pageSize: pageSize,
      );
}
