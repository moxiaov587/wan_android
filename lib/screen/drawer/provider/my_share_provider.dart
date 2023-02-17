part of 'drawer_provider.dart';

const String kMyShareProvider = 'kMyShareProvider';

final AutoDisposeStateNotifierProvider<MyShareArticlesNotifier,
        RefreshListViewState<ArticleModel>> myShareArticlesProvider =
    StateNotifierProvider.autoDispose<MyShareArticlesNotifier,
        RefreshListViewState<ArticleModel>>(
  (AutoDisposeStateNotifierProviderRef<MyShareArticlesNotifier,
          RefreshListViewState<ArticleModel>>
      ref) {
    final CancelToken cancelToken = ref.cancelToken();

    final Http http = ref.watch(networkProvider);

    return MyShareArticlesNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
      http: http,
      cancelToken: cancelToken,
    )..initData();
  },
  name: kMyShareProvider,
);

class MyShareArticlesNotifier
    extends BaseRefreshListViewNotifier<ArticleModel> {
  MyShareArticlesNotifier(
    super.state, {
    required this.http,
    this.cancelToken,
  });

  final Http http;

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await http.fetchShareArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    ))
        .shareArticles
        .toRefreshListViewStateData();
  }

  Future<bool> add({
    required String title,
    required String link,
  }) async {
    try {
      DialogUtils.loading();

      await http.addShareArticle(
        title: title,
        link: link,
      );

      initData();

      return true;
    } catch (e, s) {
      DialogUtils.danger(ViewError.create(e, s).errorMessage(S.current.failed));

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }

  Future<bool> requestDeleteShare({
    required int articleId,
  }) async {
    try {
      await http.deleteShareArticle(
        articleId: articleId,
      );

      return true;
    } catch (e, s) {
      DialogUtils.danger(ViewError.create(e, s).errorMessage(S.current.failed));

      return false;
    }
  }

  void destroy(int id) {
    state.whenOrNull((int pageNum, bool isLastPage, List<ArticleModel> list) {
      final List<ArticleModel> filterList =
          list.where((ArticleModel article) => article.id != id).toList();
      state = RefreshListViewStateData<ArticleModel>(
        pageNum: pageNum,
        isLastPage: isLastPage,
        list: filterList,
      );

      if (filterList.isEmpty) {
        if (!isLastPage) {
          initData();
        }
      }
    });
  }
}
