import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/wan_android_api.dart';
import '../../../app/provider/provider.dart';
import '../../../app/provider/view_state.dart';
import '../../../database/hive_boxes.dart';
import '../../../database/model/models.dart' show SearchHistory;
import '../../../model/models.dart';

part 'project_provider.dart';
part 'question_provider.dart';
part 'search_provider.dart';
part 'square_provider.dart';

const String kHomeArticleProvider = 'kHomeArticleProvider';
const String kSquareArticleProvider = 'kSquareArticleProvider';
const String kSearchArticleProvider = 'kSearchArticleProvider';
const String kQuestionArticleProvider = 'kQuestionArticleProvider';
const String kProjectArticleProvider = 'kProjectArticleProvider';

abstract class BaseArticleNotifier
    extends BaseRefreshListViewNotifier<ArticleModel> {
  BaseArticleNotifier(RefreshListViewState<ArticleModel> state)
      : super(
          state,
          initialPageNum: 0,
        );

  void switchCollect(
    int id, {
    required bool changedValue,
  }) {
    state.whenOrNull((int pageNum, bool isLastPage, List<ArticleModel> list) {
      state = RefreshListViewStateData<ArticleModel>(
        pageNum: pageNum,
        isLastPage: isLastPage,
        list: list
            .map((ArticleModel article) => article.id == id
                ? article.copyWith(
                    collect: changedValue,
                  )
                : article)
            .toList(),
      );
    });
  }
}

final StateNotifierProvider<BannerNotifier, ListViewState<BannerModel>>
    homeBannerProvider =
    StateNotifierProvider<BannerNotifier, ListViewState<BannerModel>>((_) {
  return BannerNotifier(
    const ListViewState<BannerModel>.loading(),
  );
});

class BannerNotifier extends BaseListViewNotifier<BannerModel> {
  BannerNotifier(ListViewState<BannerModel> state) : super(state);

  @override
  Future<List<BannerModel>> loadData() {
    return WanAndroidAPI.fetchHomeBanners();
  }
}

final StateNotifierProvider<ArticleNotifier, RefreshListViewState<ArticleModel>>
    homeArticleProvider =
    StateNotifierProvider<ArticleNotifier, RefreshListViewState<ArticleModel>>(
  (_) {
    return ArticleNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
    );
  },
  name: kHomeArticleProvider,
);

class ArticleNotifier extends BaseArticleNotifier {
  ArticleNotifier(RefreshListViewState<ArticleModel> state) : super(state);

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await WanAndroidAPI.fetchHomeArticles(
      pageNum,
      pageSize,
    ))
        .toRefreshListViewStateData();
  }
}
