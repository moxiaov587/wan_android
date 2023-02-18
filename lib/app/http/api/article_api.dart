part of 'api.dart';

extension ArticleAPI on Http {
  Future<List<ArticleModel>> fetchHomeTopArticles({
    CancelToken? cancelToken,
  }) async {
    final Response<List<dynamic>> response = await dio.get<List<dynamic>>(
      API.topArticle,
      cancelToken: cancelToken,
    );

    return response.data!
        .map((dynamic e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PaginationData<ArticleModel>> fetchHomeArticles(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      API.article(
        pageNum: pageNum,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return PaginationData<ArticleModel>.fromJson(
      response.data!,
      (Object? obj) {
        if (obj is Map<String, dynamic>) {
          return ArticleModel.fromJson(obj);
        }

        return ArticleModel(id: -1, link: '', title: '');
      },
    );
  }

  Future<PaginationData<ArticleModel>> fetchSquareArticles(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      API.square(
        pageNum: pageNum,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return PaginationData<ArticleModel>.fromJson(
      response.data!,
      (Object? obj) {
        if (obj is Map<String, dynamic>) {
          return ArticleModel.fromJson(obj);
        }

        return ArticleModel(id: -1, link: '', title: '');
      },
    );
  }

  Future<PaginationData<ArticleModel>> fetchQuestionArticles(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      API.qa(
        pageNum: pageNum,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return PaginationData<ArticleModel>.fromJson(
      response.data!,
      (Object? obj) {
        if (obj is Map<String, dynamic>) {
          return ArticleModel.fromJson(obj);
        }

        return ArticleModel(id: -1, link: '', title: '');
      },
    );
  }

  Future<List<ProjectTypeModel>> fetchProjectTypes({
    CancelToken? cancelToken,
  }) async {
    final Response<List<dynamic>> response = await dio.get<List<dynamic>>(
      API.projectType,
      cancelToken: cancelToken,
      options: Options(
        extra: buildMethodGetCacheOptionsExtra(
          needCache: true,
          isDiskCache: true,
        ),
      ),
    );

    return response.data!
        .map(
          (dynamic e) => ProjectTypeModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<PaginationData<ArticleModel>> fetchProjectArticles(
    int pageNum,
    int pageSize, {
    required int categoryId,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      API.project(
        pageNum: pageNum,
        categoryId: categoryId,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return PaginationData<ArticleModel>.fromJson(
      response.data!,
      (Object? obj) {
        if (obj is Map<String, dynamic>) {
          return ArticleModel.fromJson(obj);
        }

        return ArticleModel(id: -1, link: '', title: '');
      },
    );
  }

  Future<ArticleModel?> fetchArticleInfo({
    required int articleId,
    CancelToken? cancelToken,
  }) async {
    final Response<dynamic> response = await dio.get<dynamic>(
      API.articleInfo(articleId: articleId),
      cancelToken: cancelToken,
    );

    if (response.data == null) {
      return null;
    }

    return ArticleModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PaginationData<ArticleModel>> fetchArticlesByAuthor(
    int pageNum,
    int pageSize, {
    required String author,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      API.articleByAuthor(
        author: author,
        pageNum: pageNum,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return PaginationData<ArticleModel>.fromJson(
      response.data!,
      (Object? obj) {
        if (obj is Map<String, dynamic>) {
          return ArticleModel.fromJson(obj);
        }

        return ArticleModel(id: -1, link: '', title: '');
      },
    );
  }
}
