import 'package:dio/dio.dart';

import '../../app/provider/view_state.dart' show ModelToRefreshListData;
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

  static Future<ModelToRefreshListData<ArticleModel>> fetchHomeArticles(
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

    return ModelToRefreshListData<ArticleModel>.fromJson(
      json: response.data!,
      formJson: ArticleModel.fromJson,
    );
  }

  static Future<ModelToRefreshListData<ArticleModel>> fetchSquareArticles(
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
    return ModelToRefreshListData<ArticleModel>.fromJson(
      json: response.data!,
      formJson: ArticleModel.fromJson,
    );
  }

  static Future<ModelToRefreshListData<ArticleModel>> fetchQuestionArticles(
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

    return ModelToRefreshListData<ArticleModel>.fromJson(
      json: response.data!,
      formJson: ArticleModel.fromJson,
    );
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

  static Future<ModelToRefreshListData<ArticleModel>> fetchProjectArticles(
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

    return ModelToRefreshListData<ArticleModel>.fromJson(
      json: response.data!,
      formJson: ArticleModel.fromJson,
    );
  }

  static Future<ModelToRefreshListData<ArticleModel>> fetchSearchArticles(
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

    return ModelToRefreshListData<ArticleModel>.fromJson(
      json: response.data!,
      formJson: ArticleModel.fromJson,
    );
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
    required String repassword,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.post<Map<String, dynamic>>(
      API.register,
      queryParameters: <String, dynamic>{
        'username': username,
        'password': password,
        'repassword': repassword,
      },
      cancelToken: cancelToken,
    );

    return UserModel.fromJson(response.data!);
  }

  static Future<void> logout() async {
    await HttpUtils.get<dynamic>(API.logout);
  }

  static Future<UserInfoModel> fetchUserInfo({
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.post<Map<String, dynamic>>(
      API.userInfo,
      cancelToken: cancelToken,
    );

    return UserInfoModel.fromJson(response.data!);
  }

  static Future<ModelToRefreshListData<UserPointsModel>> fetchPointsRank(
    int pageNum, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.get<Map<String, dynamic>>(
      API.pointsRank(
        pageNum: pageNum,
      ),
      cancelToken: cancelToken,
    );
    return ModelToRefreshListData<UserPointsModel>.fromJson(
      json: response.data!,
      formJson: UserPointsModel.fromJson,
    );
  }

  static Future<ModelToRefreshListData<PointsModel>> fetchUserPointsRecord(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.get<Map<String, dynamic>>(
      API.userPointsRecord(
        pageNum: pageNum,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return ModelToRefreshListData<PointsModel>.fromJson(
      json: response.data!,
      formJson: PointsModel.fromJson,
    );
  }

  static Future<ModelToRefreshListData<CollectedArticleModel>>
      fetchCollectedArticles(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.get<Map<String, dynamic>>(
      API.collectedArticles(
        pageNum: pageNum,
      ),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return ModelToRefreshListData<CollectedArticleModel>.fromJson(
      json: response.data!,
      formJson: CollectedArticleModel.fromJson,
    );
  }

  static Future<CollectedArticleModel?> addCollectedArticle({
    required String title,
    required String author,
    required String link,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.post<Map<String, dynamic>>(
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

  static Future<void> updateCollectedArticle({
    required int id,
    required String title,
    required String author,
    required String link,
  }) async {
    await HttpUtils.post<dynamic>(
      API.updateCollectedArticle(collectId: id),
      queryParameters: <String, dynamic>{
        'title': title,
        'author': author,
        'link': link,
      },
    );
  }

  static Future<void> addCollectedArticleByArticleId({
    required int articleId,
  }) async {
    await HttpUtils.post<dynamic>(
        API.addCollectedArticleByArticleId(articleId: articleId));
  }

  static Future<void> deleteCollectedArticleByArticleId({
    required int articleId,
  }) async {
    await HttpUtils.post<dynamic>(
        API.deleteCollectedArticleByArticleId(articleId: articleId));
  }

  static Future<void> deleteCollectedArticleByCollectId({
    required int collectId,
    int? articleId,
  }) async {
    await HttpUtils.post<dynamic>(
      API.deleteCollectedArticleByCollectId(collectId: collectId),
      queryParameters: <String, dynamic>{
        'originId': articleId ?? -1,
      },
    );
  }

  static Future<List<CollectedWebsiteModel>> fetchCollectedWebsites({
    CancelToken? cancelToken,
  }) async {
    final Response<List<dynamic>> response = await HttpUtils.get<List<dynamic>>(
      API.collectedWebsites,
      cancelToken: cancelToken,
    );

    return response.data!
        .map((dynamic e) =>
            CollectedWebsiteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<CollectedWebsiteModel?> addCollectedWebsite({
    required String title,
    required String link,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.post<Map<String, dynamic>>(
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

  static Future<void> updateCollectedWebsite({
    required int id,
    required String title,
    required String link,
  }) async {
    await HttpUtils.post<dynamic>(
      API.updateCollectedWebsite,
      queryParameters: <String, dynamic>{
        'id': id,
        'name': title,
        'link': link,
      },
    );
  }

  static Future<void> deleteCollectedWebsite({
    required int id,
  }) async {
    await HttpUtils.post<dynamic>(
      API.deleteCollectedWebsite,
      queryParameters: <String, dynamic>{
        'id': id,
      },
    );
  }
}
