part of 'api.dart';

extension SearchAPI on Http {
  Future<PaginationData<ArticleModel>> fetchSearchArticles(
    int pageNum,
    int pageSize, {
    required String keyword,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.post<Map<String, dynamic>>(
      API.search(pageNum: pageNum),
      queryParameters: <String, dynamic>{
        'page_size': pageSize,
        'k': keyword,
      },
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

  Future<List<SearchKeywordModel>> fetchSearchPopularKeywords({
    CancelToken? cancelToken,
  }) async {
    final Response<List<dynamic>> response = await dio.get(
      API.searchPopularKeywords,
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
          (dynamic e) => SearchKeywordModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
