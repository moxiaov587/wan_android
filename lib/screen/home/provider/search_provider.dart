part of 'home_provider.dart';

typedef SearchArticlesProvider = AutoDisposeStateNotifierProvider<
    SearchNotifier, RefreshListViewState<ArticleModel>>;

final AutoDisposeStateNotifierProviderFamily<SearchNotifier,
        RefreshListViewState<ArticleModel>, String> searchArticlesProvider =
    StateNotifierProvider.family.autoDispose<SearchNotifier,
        RefreshListViewState<ArticleModel>, String>(
  (
    AutoDisposeStateNotifierProviderRef<SearchNotifier,
            RefreshListViewState<ArticleModel>>
        ref,
    String keyword,
  ) {
    final CancelToken cancelToken = ref.cancelToken();

    final Http http = ref.watch(networkProvider);

    return SearchNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
      keyword: keyword,
      http: http,
      cancelToken: cancelToken,
    )..initData();
  },
  name: kSearchArticleProvider,
);

class SearchNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  SearchNotifier(
    super.state, {
    required this.keyword,
    required this.http,
    this.cancelToken,
  }) : super(initialPageNum: 0);

  final String keyword;

  final Http http;

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async =>
      (await http.fetchSearchArticles(
        pageNum,
        pageSize,
        keyword: keyword,
        cancelToken: cancelToken,
      ))
          .toRefreshListViewStateData();
}

@riverpod
Future<List<SearchKeywordModel>> searchPopularKeyword(
  SearchPopularKeywordRef ref,
) {
  final CancelToken cancelToken = ref.cancelToken();

  return ref
      .watch(networkProvider)
      .fetchSearchPopularKeywords(cancelToken: cancelToken);
}
