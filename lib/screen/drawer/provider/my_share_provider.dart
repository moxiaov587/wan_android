part of 'drawer_provider.dart';

const String kMyShareProvider = 'kMyShareProvider';

final AutoDisposeStateNotifierProvider<MyShareArticlesNotifier,
        RefreshListViewState<ArticleModel>> myShareArticlesProvider =
    StateNotifierProvider.autoDispose<MyShareArticlesNotifier,
        RefreshListViewState<ArticleModel>>(
  (AutoDisposeStateNotifierProviderRef<MyShareArticlesNotifier,
          RefreshListViewState<ArticleModel>>
      ref) {
    final CancelToken cancelToken = CancelToken();

    ref.onDispose(() {
      cancelToken.cancel();
    });

    return MyShareArticlesNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
      cancelToken: cancelToken,
    );
  },
  name: kMyShareProvider,
);

class MyShareArticlesNotifier
    extends BaseRefreshListViewNotifier<ArticleModel> {
  MyShareArticlesNotifier(
    RefreshListViewState<ArticleModel> state, {
    this.cancelToken,
  }) : super(state);

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await WanAndroidAPI.fetchShareArticles(
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

      await WanAndroidAPI.addShareArticle(
        title: title,
        link: link,
      );

      initData();

      return true;
    } catch (e, s) {
      DialogUtils.danger(getError(e, s).message ?? S.current.failed);

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }

  Future<bool> requestDeleteShare({
    required int articleId,
  }) async {
    try {
      await WanAndroidAPI.deleteShareArticle(
        articleId: articleId,
      );

      return true;
    } catch (e, s) {
      DialogUtils.danger(getError(e, s).message ?? S.current.failed);

      return false;
    }
  }

  void destroy(int id) {
    state.whenOrNull((int pageNum, bool isLastPage, List<ArticleModel> list) {
      final List<ArticleModel> setIsDismissList = list
          .map((ArticleModel article) => article.id == id
              ? article.copyWith(
                  isDestroy: true,
                )
              : article)
          .toList();
      state = RefreshListViewStateData<ArticleModel>(
        pageNum: pageNum,
        isLastPage: isLastPage,
        list: setIsDismissList,
      );

      if (setIsDismissList
              .firstWhereOrNull((ArticleModel article) => !article.isDestroy) ==
          null) {
        if (isLastPage) {
          Future<void>.delayed(Duration.zero, () {
            state = RefreshListViewStateData<ArticleModel>(
              pageNum: pageNum,
              isLastPage: isLastPage,
              list: <ArticleModel>[],
            );
          });
        } else {
          initData();
        }
      }
    });
  }
}
