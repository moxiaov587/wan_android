part of 'home_provider.dart';

final StateNotifierProvider<QuestionNotifier,
        RefreshListViewState<ArticleModel>> questionArticleProvider =
    StateNotifierProvider<QuestionNotifier, RefreshListViewState<ArticleModel>>(
        (_) {
  return QuestionNotifier(
    const RefreshListViewState<ArticleModel>.loading(),
  );
});

class QuestionNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  QuestionNotifier(
    RefreshListViewState<ArticleModel> state, {
    this.cancelToken,
  }) : super(
          state,
          initialPageNum: 0,
        );

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData(
      {required int pageNum, required int pageSize}) async {
    return (await WanAndroidAPI.fetchQuestionArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }
}
