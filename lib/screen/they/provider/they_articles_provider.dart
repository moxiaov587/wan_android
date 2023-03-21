part of 'they_provider.dart';

typedef TheyArticlesProvider = AutoDisposeStateNotifierProvider<
    TheyArticlesNotifier, RefreshListViewState<ArticleModel>>;

final AutoDisposeStateNotifierProviderFamily<TheyArticlesNotifier,
        RefreshListViewState<ArticleModel>, String> theyArticlesProvider =
    StateNotifierProvider.family.autoDispose<TheyArticlesNotifier,
        RefreshListViewState<ArticleModel>, String>((
  AutoDisposeStateNotifierProviderRef<TheyArticlesNotifier,
          RefreshListViewState<ArticleModel>>
      ref,
  String author,
) {
  final CancelToken cancelToken = ref.cancelToken();

  final Http http = ref.watch(networkProvider);

  return TheyArticlesNotifier(
    const RefreshListViewState<ArticleModel>.loading(),
    author: author,
    http: http,
    cancelToken: cancelToken,
  )..initData();
});

class TheyArticlesNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  TheyArticlesNotifier(
    super.state, {
    required this.author,
    required this.http,
    this.cancelToken,
  });

  final String author;
  final Http http;
  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async => (await http.fetchArticlesByAuthor(
      pageNum,
      pageSize,
      author: author,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
}
