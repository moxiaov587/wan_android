part of 'home_provider.dart';

final StateNotifierProvider<SquareNotifier, RefreshListViewState<ArticleModel>>
    squareArticleProvider =
    StateNotifierProvider<SquareNotifier, RefreshListViewState<ArticleModel>>(
        (_) {
  return SquareNotifier(
    const RefreshListViewState<ArticleModel>.loading(),
  );
});

class SquareNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  SquareNotifier(
    RefreshListViewState<ArticleModel> state, {
    this.cancelToken,
  }) : super(state);

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData(
      {required int pageNum, required int pageSize}) async {
    final RefreshArticleListModel data =
        await WanAndroidAPI.fetchSquareArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    );

    return RefreshListViewStateData<ArticleModel>(
      nextPageNum: data.curPage,
      isLastPage: data.over,
      value: data.datas,
    );
  }
}
