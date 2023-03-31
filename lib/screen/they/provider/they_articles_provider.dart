part of 'they_provider.dart';

@riverpod
class TheyArticle extends _$TheyArticle with LoadMoreMixin<ArticleModel> {
  late Http http;

  @override
  Future<PaginationData<ArticleModel>> build(
    String author, {
    int? pageNum,
    int? pageSize,
  }) {
    final CancelToken cancelToken = ref.cancelToken();

    http = ref.watch(networkProvider);

    return http.fetchArticlesByAuthor(
      pageNum ?? initialPageNum,
      pageSize ?? initialPageSize,
      author: author,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<ArticleModel>> Function(int pageNum, int pageSize)
      get buildMore => (int pageNum, int pageSize) => build(
            author,
            pageNum: pageNum,
            pageSize: pageSize,
          );
}
