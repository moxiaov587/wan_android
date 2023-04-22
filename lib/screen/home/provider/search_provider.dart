part of 'home_provider.dart';

@riverpod
class SearchArticle extends _$SearchArticle with LoadMoreMixin<ArticleModel> {
  late Http _http;

  @override
  Future<PaginationData<ArticleModel>> build(
    String keyword, {
    int pageNum = 0,
    int pageSize = kDefaultPageSize,
  }) async {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    final PaginationData<ArticleModel> data = await _http.fetchSearchArticles(
      pageNum,
      pageSize,
      keyword: keyword,
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
      build(keyword, pageNum: pageNum, pageSize: pageSize);
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
