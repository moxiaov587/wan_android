part of 'home_provider.dart';

@riverpod
class QuestionArticle extends _$QuestionArticle
    with LoadMoreMixin<ArticleModel> {
  @override
  int get initialPageNum => 0;

  late Http http;

  @override
  Future<PaginationData<ArticleModel>> build({
    int? pageNum,
    int? pageSize,
  }) {
    final CancelToken cancelToken = ref.cancelToken();

    http = ref.watch(networkProvider);

    return http.fetchQuestionArticles(
      pageNum ?? initialPageNum,
      pageSize ?? initialPageSize,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<ArticleModel>> Function(int pageNum, int pageSize)
      get buildMore => (int pageNum, int pageSize) => build(
            pageNum: pageNum,
            pageSize: pageSize,
          );
}
