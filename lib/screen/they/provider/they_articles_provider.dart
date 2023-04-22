part of 'they_provider.dart';

@riverpod
class TheyArticle extends _$TheyArticle with LoadMoreMixin<ArticleModel> {
  late Http _http;

  @override
  Future<PaginationData<ArticleModel>> build(
    String author, {
    int pageNum = kDefaultPageNum,
    int pageSize = kDefaultPageSize,
  }) {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    return _http.fetchArticlesByAuthor(
      pageNum,
      pageSize,
      author: author,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<ArticleModel>> buildMore(int pageNum, int pageSize) =>
      build(author, pageNum: pageNum, pageSize: pageSize);
}
