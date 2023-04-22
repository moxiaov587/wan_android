part of 'they_provider.dart';

@riverpod
class TheyPoints extends _$TheyPoints {
  late Http _http;

  @override
  Future<UserPointsModel> build(int userId) async {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    return (await _http.fetchShareArticlesByUserId(
      1,
      0,
      userId: userId,
      cancelToken: cancelToken,
    ))
        .userPoints;
  }
}

@riverpod
class TheyShare extends _$TheyShare with LoadMoreMixin<ArticleModel> {
  late Http _http;

  @override
  Future<PaginationData<ArticleModel>> build(
    int userId, {
    int pageNum = kDefaultPageNum,
    int pageSize = kDefaultPageSize,
  }) async {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    return (await _http.fetchShareArticlesByUserId(
      pageNum,
      pageSize,
      userId: userId,
      cancelToken: cancelToken,
    ))
        .shareArticles;
  }

  @override
  Future<PaginationData<ArticleModel>> buildMore(int pageNum, int pageSize) =>
      build(userId, pageNum: pageNum, pageSize: pageSize);
}
