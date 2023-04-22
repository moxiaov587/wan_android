part of 'drawer_provider.dart';

@riverpod
class MyShareArticle extends _$MyShareArticle with LoadMoreMixin<ArticleModel> {
  late Http _http;

  @override
  Future<PaginationData<ArticleModel>> build({
    int pageNum = kDefaultPageNum,
    int pageSize = kDefaultPageSize,
  }) async {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    return (await _http.fetchShareArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    ))
        .shareArticles;
  }

  @override
  Future<PaginationData<ArticleModel>> buildMore(int pageNum, int pageSize) =>
      build(pageNum: pageNum, pageSize: pageSize);

  Future<bool> add({
    required String title,
    required String link,
  }) async {
    try {
      DialogUtils.loading();

      await _http.addShareArticle(
        title: title,
        link: link,
      );

      ref.invalidateSelf();

      return true;
    } on Exception catch (e, s) {
      DialogUtils.danger(
        AppException.create(e, s).errorMessage(S.current.failed),
      );

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }

  Future<bool> requestDeleteShare({
    required int articleId,
  }) async {
    try {
      await _http.deleteShareArticle(
        articleId: articleId,
      );

      return true;
    } on Exception catch (e, s) {
      DialogUtils.danger(
        AppException.create(e, s).errorMessage(S.current.failed),
      );

      return false;
    }
  }

  Future<void>? destroy(int index) => state.whenOrNull(
        data: (PaginationData<ArticleModel> data) async {
          await update(
            (_) => data.copyWith(datas: data.datas..removeAt(index)),
          );

          if (data.datas.length == 1) {
            if (!data.over) {
              ref.invalidateSelf();
            }
          }
        },
      );
}
