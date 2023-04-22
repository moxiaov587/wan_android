part of 'home_provider.dart';

@riverpod
class QuestionArticle extends _$QuestionArticle
    with LoadMoreMixin<ArticleModel> {
  late Http _http;

  @override
  Future<PaginationData<ArticleModel>> build({
    int pageNum = 0,
    int pageSize = kDefaultPageSize,
  }) {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    return _http.fetchQuestionArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<ArticleModel>> buildMore(int pageNum, int pageSize) =>
      build(pageNum: pageNum, pageSize: pageSize);
}
