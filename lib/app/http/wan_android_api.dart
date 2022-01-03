import 'package:dio/dio.dart';

import '../../model/models.dart';
import 'api.dart';
import 'http.dart';

class WanAndroidAPI {
  const WanAndroidAPI._();

  static Future<List<BannerModel>> fetchHomeBanners({
    CancelToken? cancelToken,
  }) async {
    final Response<List<dynamic>> response = await HttpUtils.get(
      API.banner,
      cancelToken: cancelToken,
    );

    return response.data!
        .map((dynamic e) => BannerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

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

  static Future<RefreshArticleListModel> fetchProjectArticles(
    int pageNum,
    int pageSize, {
    required int categoryId,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.get<Map<String, dynamic>>(
      API.project(
        pageNum: pageNum,
        categoryId: categoryId,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return RefreshArticleListModel.fromJson(response.data!);
  }

  static Future<RefreshArticleListModel> fetchSearchArticles(
    int pageNum,
    int pageSize, {
    required String keyword,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.post<Map<String, dynamic>>(
      API.search(pageNum: pageNum),
      queryParameters: <String, dynamic>{
        'page_size': pageSize,
        'k': keyword,
      },
      cancelToken: cancelToken,
    );

    return RefreshArticleListModel.fromJson(response.data!);
  }

  static Future<List<SearchKeywordModel>> fetchSearchPopularKeywords({
    CancelToken? cancelToken,
  }) async {
    final Response<List<dynamic>> response = await HttpUtils.get(
      API.searchPopularKeywords,
      cancelToken: cancelToken,
      needCache: true,
    );

    return response.data!
        .map((dynamic e) =>
            SearchKeywordModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<UserModel> login({
    required String username,
    required String password,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.post<Map<String, dynamic>>(
      API.login,
      queryParameters: <String, dynamic>{
        'username': username,
        'password': password,
      },
      cancelToken: cancelToken,
    );

    return UserModel.fromJson(response.data!);
  }

  static Future<UserModel> register({
    required String username,
    required String password,
    required String rePassword,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.post<Map<String, dynamic>>(
      API.register,
      queryParameters: <String, dynamic>{
        'username': username,
        'password': password,
        'repassword': rePassword,
      },
      cancelToken: cancelToken,
    );

    return UserModel.fromJson(response.data!);
  }

  static Future<void> logout() async {
    await HttpUtils.get<dynamic>(API.logout);
  }
}
