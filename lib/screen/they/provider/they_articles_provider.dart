part of 'they_provider.dart';

final AutoDisposeStateNotifierProviderFamily<TheyArticlesNotifier,
        RefreshListViewState<ArticleModel>, String> theyArticlesProvider =
    StateNotifierProvider.family.autoDispose<TheyArticlesNotifier,
        RefreshListViewState<ArticleModel>, String>((
  AutoDisposeStateNotifierProviderRef<TheyArticlesNotifier,
          RefreshListViewState<ArticleModel>>
      ref,
  String author,
) {
  final CancelToken cancelToken = CancelToken();

  ref.onDispose(() {
    cancelToken.cancel();
  });

  return TheyArticlesNotifier(
    const RefreshListViewState<ArticleModel>.loading(),
    author: author,
    cancelToken: cancelToken,
  );
});

class TheyArticlesNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  TheyArticlesNotifier(
    super.state, {
    required this.author,
    this.cancelToken,
  });

  final String author;
  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await WanAndroidAPI.fetchArticlesByAuthor(
      pageNum,
      pageSize,
      author: author,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }
}
