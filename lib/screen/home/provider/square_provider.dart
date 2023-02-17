part of 'home_provider.dart';

final AutoDisposeStateNotifierProvider<SquareNotifier,
        RefreshListViewState<ArticleModel>> squareArticleProvider =
    StateNotifierProvider.autoDispose<SquareNotifier,
        RefreshListViewState<ArticleModel>>(
  (AutoDisposeStateNotifierProviderRef<SquareNotifier,
          RefreshListViewState<ArticleModel>>
      ref) {
    final CancelToken cancelToken = ref.cancelToken();

    final Http http = ref.watch(networkProvider);

    return SquareNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
      http: http,
      cancelToken: cancelToken,
    )..initData();
  },
  name: kSquareArticleProvider,
);

class SquareNotifier extends BaseRefreshListViewNotifier<ArticleModel>
    with ArticleNotifierSwitchCollectMixin {
  SquareNotifier(
    super.state, {
    required this.http,
    this.cancelToken,
  }) : super(initialPageNum: 0);

  final Http http;
  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await http.fetchSquareArticles(
      pageNum,
      pageSize,
    ))
        .toRefreshListViewStateData();
  }
}
