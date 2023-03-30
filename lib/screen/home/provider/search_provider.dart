part of 'home_provider.dart';

@riverpod
class SearchArticle extends _$SearchArticle with LoadMoreMixin<ArticleModel> {
  late Http http;

  @override
  int get initialPageNum => 0;

  @override
  Future<PaginationData<ArticleModel>> build(
    String keyword, {
    int? pageNum,
    int? pageSize,
  }) {
    final CancelToken cancelToken = ref.cancelToken();

    http = ref.watch(networkProvider);

    return http.fetchSearchArticles(
      pageNum ?? initialPageNum,
      pageSize ?? initialPageSize,
      keyword: keyword,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<ArticleModel>> Function(int pageNum, int pageSize)
      get buildMore => (int pageNum, int pageSize) => build(
            keyword,
            pageNum: pageNum,
            pageSize: pageSize,
          );
}

@riverpod
Future<List<SearchKeywordModel>> searchPopularKeyword(
  SearchPopularKeywordRef ref,
) {
  final CancelToken cancelToken = ref.cancelToken();

  return ref
      .watch(networkProvider)
      .fetchSearchPopularKeywords(cancelToken: cancelToken);
}
