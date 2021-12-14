import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/wan_android_api.dart';
import '../../../app/provider/provider.dart';
import '../../../app/provider/view_state.dart';
import '../../../model/models.dart';

part 'project_provider.dart';
part 'question_provider.dart';
part 'square_provider.dart';

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
  Future<RefreshListViewStateData<ArticleModel>> loadData(
      {required int pageNum, required int pageSize}) async {
    final RefreshArticleListModel data = await WanAndroidAPI.fetchHomeArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    );

    return RefreshListViewStateData<ArticleModel>(
      nextPageNum: data.curPage,
      isLastPage: data.over,
      list: data.datas,
    );
  }
}
