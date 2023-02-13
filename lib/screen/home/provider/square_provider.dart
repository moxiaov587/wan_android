part of 'home_provider.dart';

final AutoDisposeStateNotifierProvider<SquareNotifier,
        RefreshListViewState<ArticleModel>> squareArticleProvider =
    StateNotifierProvider.autoDispose<SquareNotifier,
        RefreshListViewState<ArticleModel>>(
  (_) {
    return SquareNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
    );
  },
  name: kSquareArticleProvider,
);

class SquareNotifier extends BaseRefreshListViewNotifier<ArticleModel>
    with ArticleNotifierSwitchCollectMixin {
  SquareNotifier(super.state) : super(initialPageNum: 0);

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await WanAndroidAPI.fetchSquareArticles(
      pageNum,
      pageSize,
    ))
        .toRefreshListViewStateData();
  }
}
