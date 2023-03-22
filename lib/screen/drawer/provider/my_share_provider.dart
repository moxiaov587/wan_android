part of 'drawer_provider.dart';

const String kMyShareProvider = 'kMyShareProvider';

typedef MyShareArticlesProvider = AutoDisposeStateNotifierProvider<
    MyShareArticlesNotifier, RefreshListViewState<ArticleModel>>;

final MyShareArticlesProvider myShareArticlesProvider = StateNotifierProvider
    .autoDispose<MyShareArticlesNotifier, RefreshListViewState<ArticleModel>>(
  (
    AutoDisposeStateNotifierProviderRef<MyShareArticlesNotifier,
            RefreshListViewState<ArticleModel>>
        ref,
  ) {
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
  }) async =>
      (await http.fetchShareArticles(
        pageNum,
        pageSize,
        cancelToken: cancelToken,
      ))
          .shareArticles
          .toRefreshListViewStateData();

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

      await initData();

      return true;
    } on Exception catch (e, s) {
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
    } on Exception catch (e, s) {
      DialogUtils.danger(ViewError.create(e, s).errorMessage(S.current.failed));

      return false;
    }
  }

  Future<void>? destroy(int index) => state.whenOrNull((
        List<ArticleModel> list,
        int pageNum,
        bool isLastPage,
      ) async {
        state = RefreshListViewStateData<ArticleModel>(
          pageNum: pageNum,
          isLastPage: isLastPage,
          list: list..removeAt(index),
        );

        if (list.length == 1) {
          if (!isLastPage) {
            await initData();
          }
        }
      });
}
