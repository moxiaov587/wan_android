part of 'api.dart';

extension ShareAPI on Http {
  Future<TheyShareModel> fetchShareArticlesByUserId(
    int pageNum,
    int pageSize, {
    required int userId,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      API.shareArticleByUserId(userId: userId, pageNum: pageNum),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return TheyShareModel.fromJson(response.data!);
  }

  Future<TheyShareModel> fetchShareArticles(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<dynamic> response = await dio.get<dynamic>(
      API.shareArticle(pageNum: pageNum),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return TheyShareModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> addShareArticle({
    required String title,
    required String link,
  }) async {
    await dio.post<Map<String, dynamic>>(
      API.addShareArticle,
      queryParameters: <String, dynamic>{
        'title': title,
        'link': link,
      },
    );
  }

  Future<void> deleteShareArticle({required int articleId}) async {
    await dio.post<dynamic>(
      API.deleteShareArticle(articleId: articleId),
    );
  }
}
