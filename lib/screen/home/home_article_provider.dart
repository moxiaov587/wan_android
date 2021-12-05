import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/wan_android_api.dart';
import '../../../app/provider/provider.dart';
import '../../../app/provider/view_state.dart';
import '../../model/article_model.dart';

final StateNotifierProvider<ArticleNotifier, RefreshListViewState<ArticleModel>>
    homeArticleProvider =
    StateNotifierProvider<ArticleNotifier, RefreshListViewState<ArticleModel>>(
        (_) {
  return ArticleNotifier(
    const RefreshListViewState<ArticleModel>.loading(),
  );
});

class ArticleNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  ArticleNotifier(
    RefreshListViewState<ArticleModel> state, {
    this.cancelToken,
  }) : super(state);

  final CancelToken? cancelToken;

  @override
  Future<List<ArticleModel>> loadData({int? pageNum}) async {
    return WanAndroidAPI.fetchArticles(
      pageNum!,
      cancelToken: cancelToken,
    );
  }
}
