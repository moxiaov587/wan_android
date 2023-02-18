part of 'api.dart';

extension CollectAPI on Http {
  Future<PaginationData<CollectedArticleModel>> fetchCollectedArticles(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      API.collectedArticles(
        pageNum: pageNum,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return PaginationData<CollectedArticleModel>.fromJson(
      response.data!,
      (Object? obj) {
        if (obj is Map<String, dynamic>) {
          return CollectedArticleModel.fromJson(obj);
        }

        return CollectedArticleModel(id: -1, link: '');
      },
    );
  }

  Future<CollectedArticleModel?> addCollectedArticle({
    required String title,
    required String author,
    required String link,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.post<Map<String, dynamic>>(
      API.addCollectedArticle,
      queryParameters: <String, dynamic>{
        'title': title,
        'author': author,
        'link': link,
      },
    );

    if (response.data != null) {
      return CollectedArticleModel.fromJson(response.data!);
    }

    return null;
  }

  Future<void> updateCollectedArticle({
    required int id,
    required String title,
    required String author,
    required String link,
  }) async {
    await dio.post<dynamic>(
      API.updateCollectedArticle(collectId: id),
      queryParameters: <String, dynamic>{
        'title': title,
        'author': author,
        'link': link,
      },
    );
  }

  Future<void> addCollectedArticleByArticleId({
    required int articleId,
  }) async {
    await dio.post<dynamic>(
      API.addCollectedArticleByArticleId(articleId: articleId),
    );
  }

  Future<void> deleteCollectedArticleByArticleId({
    required int articleId,
  }) async {
    await dio.post<dynamic>(
      API.deleteCollectedArticleByArticleId(articleId: articleId),
    );
  }

  Future<void> deleteCollectedArticleByCollectId({
    required int collectId,
    int? articleId,
  }) async {
    await dio.post<dynamic>(
      API.deleteCollectedArticleByCollectId(collectId: collectId),
      queryParameters: <String, dynamic>{
        'originId': articleId ?? -1,
      },
    );
  }

  Future<List<CollectedWebsiteModel>> fetchCollectedWebsites({
    CancelToken? cancelToken,
  }) async {
    final Response<List<dynamic>> response = await dio.get<List<dynamic>>(
      API.collectedWebsites,
      cancelToken: cancelToken,
    );

    return response.data!
        .map((dynamic e) =>
            CollectedWebsiteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CollectedWebsiteModel?> addCollectedWebsite({
    required String title,
    required String link,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.post<Map<String, dynamic>>(
      API.addCollectedWebsite,
      queryParameters: <String, dynamic>{
        'name': title,
        'link': link,
      },
    );

    if (response.data != null) {
      return CollectedWebsiteModel.fromJson(response.data!);
    }

    return null;
  }

  Future<void> updateCollectedWebsite({
    required int id,
    required String title,
    required String link,
  }) async {
    await dio.post<dynamic>(
      API.updateCollectedWebsite,
      queryParameters: <String, dynamic>{
        'id': id,
        'name': title,
        'link': link,
      },
    );
  }

  Future<void> deleteCollectedWebsite({
    required int id,
  }) async {
    await dio.post<dynamic>(
      API.deleteCollectedWebsite,
      queryParameters: <String, dynamic>{
        'id': id,
      },
    );
  }
}
