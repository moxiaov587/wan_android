part of 'home_provider.dart';

final AutoDisposeStateNotifierProvider<QuestionNotifier,
        RefreshListViewState<ArticleModel>> questionArticleProvider =
    StateNotifierProvider.autoDispose<QuestionNotifier,
        RefreshListViewState<ArticleModel>>(
  (AutoDisposeStateNotifierProviderRef<QuestionNotifier,
          RefreshListViewState<ArticleModel>>
      ref) {
    final CancelToken cancelToken = ref.cancelToken();

    final Http http = ref.watch(networkProvider);

    return QuestionNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
      http: http,
      cancelToken: cancelToken,
    )..initData();
  },
  name: kQuestionArticleProvider,
);

class QuestionNotifier extends BaseRefreshListViewNotifier<ArticleModel>
    with ArticleNotifierSwitchCollectMixin {
  QuestionNotifier(
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
    return (await http.fetchQuestionArticles(
      pageNum,
      pageSize,
    ))
        .toRefreshListViewStateData();
  }
}
