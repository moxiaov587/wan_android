part of 'home_provider.dart';

final StateNotifierProvider<SquareNotifier, RefreshListViewState<ArticleModel>>
    squareArticleProvider =
    StateNotifierProvider<SquareNotifier, RefreshListViewState<ArticleModel>>(
  (_) {
    return SquareNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
    );
  },
  name: kSquareArticleProvider,
);

class SquareNotifier extends BaseArticleNotifier {
  SquareNotifier(RefreshListViewState<ArticleModel> state) : super(state);

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData(
      {required int pageNum, required int pageSize}) async {
    return (await WanAndroidAPI.fetchSquareArticles(
      pageNum,
      pageSize,
    ))
        .toRefreshListViewStateData();
  }
}
