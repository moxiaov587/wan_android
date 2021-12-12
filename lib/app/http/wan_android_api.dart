import 'package:dio/dio.dart';

import '../../model/models.dart';
import 'api.dart';
import 'http.dart';

class WanAndroidAPI {
  const WanAndroidAPI._();

  static Future<RefreshArticleListModel> fetchHomeArticles(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.get<Map<String, dynamic>>(
      API.article(
        pageNum: pageNum,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );
    return RefreshArticleListModel.fromJson(response.data!);
  }

  static Future<RefreshArticleListModel> fetchSquareArticles(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.get<Map<String, dynamic>>(
      API.square(
        pageNum: pageNum,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );
    return RefreshArticleListModel.fromJson(response.data!);
  }

  static Future<RefreshArticleListModel> fetchQuestionArticles(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.get<Map<String, dynamic>>(
      API.qa(
        pageNum: pageNum,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );
    return RefreshArticleListModel.fromJson(response.data!);
  }

  static Future<List<ProjectTypeModel>> fetchProjectTypes({
    CancelToken? cancelToken,
  }) async {
    final Response<List<dynamic>> response = await HttpUtils.get<List<dynamic>>(
      API.projectType,
      cancelToken: cancelToken,
    );

    return response.data!
        .map(
            (dynamic e) => ProjectTypeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
