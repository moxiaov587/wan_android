import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/wan_android_api.dart';
import '../../../app/provider/provider.dart';
import '../../../app/provider/view_state.dart';
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

mixin ArticleNotifierSwitchCollectMixin
    on BaseRefreshListViewNotifier<ArticleModel> {
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
  BannerNotifier(super.state);

  @override
  Future<List<BannerModel>> loadData() {
    return WanAndroidAPI.fetchHomeBanners();
  }
}

final StateNotifierProvider<TopArticleNotifier, ListViewState<ArticleModel>>
    homeTopArticleProvider =
    StateNotifierProvider<TopArticleNotifier, ListViewState<ArticleModel>>((_) {
  return TopArticleNotifier(
    const ListViewState<ArticleModel>.loading(),
  );
});

class TopArticleNotifier extends BaseListViewNotifier<ArticleModel> {
  TopArticleNotifier(super.state);

  @override
  Future<List<ArticleModel>> loadData() {
    return WanAndroidAPI.fetchHomeTopArticles();
  }
}

final StateNotifierProvider<ArticleNotifier, RefreshListViewState<ArticleModel>>
    homeArticleProvider =
    StateNotifierProvider<ArticleNotifier, RefreshListViewState<ArticleModel>>(
  (StateNotifierProviderRef<ArticleNotifier, RefreshListViewState<ArticleModel>>
      ref) {
    return ref.watch(homeTopArticleProvider).when(
          (List<ArticleModel> list) => ArticleNotifier(
            const RefreshListViewState<ArticleModel>.loading(),
            topArticles: list,
          )..initData(),
          loading: () => ArticleNotifier(
            const RefreshListViewState<ArticleModel>.loading(),
          ),
          error: (int? statusCode, String? message, String? detail) =>
              ArticleNotifier(
            RefreshListViewState<ArticleModel>.error(
              statusCode: statusCode,
              message: message,
              detail: detail,
            ),
          ),
        );
  },
  name: kHomeArticleProvider,
);

class ArticleNotifier extends BaseRefreshListViewNotifier<ArticleModel>
    with ArticleNotifierSwitchCollectMixin {
  ArticleNotifier(
    super.state, {
    this.topArticles,
  }) : super(initialPageNum: 0);

  final List<ArticleModel>? topArticles;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    RefreshListViewStateData<ArticleModel> data =
        (await WanAndroidAPI.fetchHomeArticles(
      pageNum,
      pageSize,
    ))
            .toRefreshListViewStateData();

    if (pageNum == initialPageNum && topArticles != null) {
      data = data.copyWith(
        list: <ArticleModel>[
          ...topArticles!
              .map((ArticleModel article) => article.copyWith(isTop: true)),
          ...data.list,
        ],
      );
    }

    return data;
  }
}
