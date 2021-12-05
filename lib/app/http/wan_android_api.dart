import 'package:dio/dio.dart';

import '../../model/article_model.dart';
import 'api.dart';
import 'http.dart';

class WanAndroidAPI {
  const WanAndroidAPI._();

  static Future<List<ArticleModel>> fetchArticles(
    int pageNum, {
    int? cid,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await HttpUtils.get<Map<String, dynamic>>(
      API.article(
        pageNum: pageNum,
      ),
      queryParameters: cid != null ? <String, dynamic>{'cid': cid} : null,
      cancelToken: cancelToken,
    );
    return (response.data!['datas'] as List<dynamic>)
        .map((dynamic e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
