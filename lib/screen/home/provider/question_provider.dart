part of 'home_provider.dart';

final StateNotifierProvider<QuestionNotifier,
        RefreshListViewState<ArticleModel>> questionArticleProvider =
    StateNotifierProvider<QuestionNotifier, RefreshListViewState<ArticleModel>>(
  (_) {
    return QuestionNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
    );
  },
  name: kQuestionArticleProvider,
);

class QuestionNotifier extends BaseArticleNotifier {
  QuestionNotifier(
    RefreshListViewState<ArticleModel> state, {
    this.cancelToken,
  }) : super(state);

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
