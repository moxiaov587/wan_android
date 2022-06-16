part of 'home_provider.dart';

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
    final CancelToken cancelToken = CancelToken();

    ref.onDispose(() => cancelToken.cancel());

    return SearchNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
      keyword: keyword,
      cancelToken: cancelToken,
    );
  },
  name: kSearchArticleProvider,
);

class SearchNotifier extends BaseArticleNotifier {
  SearchNotifier(
    super.state, {
    required this.keyword,
    this.cancelToken,
  });

  final String keyword;

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await WanAndroidAPI.fetchSearchArticles(
      pageNum,
      pageSize,
      keyword: keyword,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }
}

final AutoDisposeStateNotifierProvider<SearchPopularKeywordNotifier,
        ListViewState<SearchKeywordModel>> searchPopularKeywordProvider =
    StateNotifierProvider.autoDispose<SearchPopularKeywordNotifier,
        ListViewState<SearchKeywordModel>>((_) {
  return SearchPopularKeywordNotifier(
    const ListViewState<SearchKeywordModel>.loading(),
  );
});

class SearchPopularKeywordNotifier
    extends BaseListViewNotifier<SearchKeywordModel> {
  SearchPopularKeywordNotifier(super.state);

  @override
  Future<List<SearchKeywordModel>> loadData() {
    return WanAndroidAPI.fetchSearchPopularKeywords();
  }
}

final AutoDisposeStateNotifierProvider<SearchHistoryNotifier,
        ListViewState<SearchHistory>> searchHistoryProvider =
    StateNotifierProvider.autoDispose<SearchHistoryNotifier,
        ListViewState<SearchHistory>>((_) {
  return SearchHistoryNotifier(
    const ListViewState<SearchHistory>.loading(),
  );
});

class SearchHistoryNotifier extends BaseListViewNotifier<SearchHistory> {
  SearchHistoryNotifier(super.state);

  @override
  Future<List<SearchHistory>> loadData() async {
    return HiveBoxes.searchHistoryBox.values.toList();
  }
}
