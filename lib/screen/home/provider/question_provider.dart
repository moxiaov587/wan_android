part of 'home_provider.dart';

final AutoDisposeStateNotifierProvider<QuestionNotifier,
        RefreshListViewState<ArticleModel>> questionArticleProvider =
    StateNotifierProvider.autoDispose<QuestionNotifier,
        RefreshListViewState<ArticleModel>>(
  (_) {
    return QuestionNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
    );
  },
  name: kQuestionArticleProvider,
);

class QuestionNotifier extends BaseRefreshListViewNotifier<ArticleModel>
    with ArticleNotifierSwitchCollectMixin {
  QuestionNotifier(super.state) : super(initialPageNum: 0);

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await WanAndroidAPI.fetchQuestionArticles(
      pageNum,
      pageSize,
    ))
        .toRefreshListViewStateData();
  }
}
