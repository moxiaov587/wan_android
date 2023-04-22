part of 'home_provider.dart';

@riverpod
class SquareArticle extends _$SquareArticle with LoadMoreMixin<ArticleModel> {
  late Http _http;

  @override
  Future<PaginationData<ArticleModel>> build({
    int pageNum = 0,
    int pageSize = kDefaultPageSize,
  }) async {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    final PaginationData<ArticleModel> data = await _http.fetchSquareArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    );

    if (pageNum == 0) {
      return data.copyWith(
        curPage: 0, // Fix curPage.
      );
    }

    return data;
  }

  @override
  Future<PaginationData<ArticleModel>> buildMore(int pageNum, int pageSize) =>
      build(pageNum: pageNum, pageSize: pageSize);
}
