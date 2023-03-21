part of 'drawer_provider.dart';

const List<String> articles = <String>[
  kHomeArticleProvider,
  kSquareArticleProvider,
  kQuestionArticleProvider,
  kProjectArticleProvider,
];

const String kMyCollectedArticleProvider = 'kMyCollectedArticleProvider';
const String kMyCollectedWebsiteProvider = 'kMyCollectedWebsiteProvider';

typedef MyCollectedArticleProvider = AutoDisposeStateNotifierProvider<
    MyCollectedArticleNotifier, RefreshListViewState<CollectedArticleModel>>;

typedef MyCollectedArticleProviderRef = AutoDisposeStateNotifierProviderRef<
    MyCollectedArticleNotifier, RefreshListViewState<CollectedArticleModel>>;

final MyCollectedArticleProvider myCollectedArticleProvider =
    StateNotifierProvider.autoDispose<MyCollectedArticleNotifier,
        RefreshListViewState<CollectedArticleModel>>(
  (MyCollectedArticleProviderRef ref) {
    final CancelToken cancelToken = ref.cancelToken();

    final Http http = ref.watch(networkProvider);

    return MyCollectedArticleNotifier(
      const RefreshListViewState<CollectedArticleModel>.loading(),
      http: http,
      cancelToken: cancelToken,
    )..initData();
  },
  name: kMyCollectedArticleProvider,
);

class MyCollectedArticleNotifier
    extends BaseRefreshListViewNotifier<CollectedArticleModel> {
  MyCollectedArticleNotifier(
    super.state, {
    required this.http,
    this.cancelToken,
  }) : super(initialPageNum: 0);
  final Http http;

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<CollectedArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async =>
      (await http.fetchCollectedArticles(
        pageNum,
        pageSize,
        cancelToken: cancelToken,
      ))
          .toRefreshListViewStateData();

  Future<bool> add({
    required String title,
    required String author,
    required String link,
  }) async {
    try {
      DialogUtils.loading();

      final CollectedArticleModel? data = await http.addCollectedArticle(
        title: title,
        author: author,
        link: link,
      );

      if (data != null) {
        await initData();

        return true;
      } else {
        DialogUtils.danger(S.current.failed);

        return false;
      }
    } on Exception catch (e, s) {
      DialogUtils.danger(ViewError.create(e, s).errorMessage(S.current.failed));

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }

  Future<bool> update({
    required int collectId,
    required String title,
    required String author,
    required String link,
  }) async =>
      await state.whenOrNull<Future<bool>?>((
        int pageNum,
        bool isLastPage,
        List<CollectedArticleModel> list,
      ) async {
        try {
          DialogUtils.loading();

          await http.updateCollectedArticle(
            id: collectId,
            title: title,
            author: author,
            link: link,
          );

          state = RefreshListViewStateData<CollectedArticleModel>(
            pageNum: pageNum,
            isLastPage: isLastPage,
            list: list
                .map(
                  (CollectedArticleModel article) => article.id == collectId
                      ? article.copyWith(
                          title: title,
                          author: author,
                          link: link,
                        )
                      : article,
                )
                .toList(),
          );

          return true;
        } on Exception catch (e, s) {
          DialogUtils.danger(
            ViewError.create(e, s).errorMessage(S.current.failed),
          );

          return false;
        } finally {
          DialogUtils.dismiss();
        }
      }) ??
      false;

  Future<bool> requestCancelCollect({
    required int collectId,
    required int? articleId,
  }) async {
    try {
      await http.deleteCollectedArticleByCollectId(
        collectId: collectId,
        articleId: articleId,
      );

      return true;
    } on Exception catch (e, s) {
      DialogUtils.danger(ViewError.create(e, s).errorMessage(S.current.failed));

      return false;
    }
  }

  Future<void>? switchCollect(
    int id, {
    required bool changedValue,
    bool triggerCompleteCallback = false,
  }) =>
      state.whenOrNull(
        (
          int pageNum,
          bool isLastPage,
          List<CollectedArticleModel> list,
        ) async {
          final List<CollectedArticleModel> changedList = list
              .map(
                (CollectedArticleModel collectedArticle) =>
                    collectedArticle.id == id
                        ? collectedArticle.copyWith(
                            collect: changedValue,
                          )
                        : collectedArticle,
              )
              .toList();

          state = RefreshListViewStateData<CollectedArticleModel>(
            pageNum: pageNum,
            isLastPage: isLastPage,
            list: changedList,
          );

          if (triggerCompleteCallback) {
            await onSwitchCollectComplete();
          }
        },
      );

  Future<void>? onSwitchCollectComplete() => state.whenOrNull(
        (int pageNum, bool isLastPage, List<CollectedArticleModel> list) async {
          if (list.none((CollectedArticleModel collect) => collect.collect)) {
            if (isLastPage) {
              state = RefreshListViewStateData<CollectedArticleModel>(
                pageNum: pageNum,
                isLastPage: isLastPage,
                list: <CollectedArticleModel>[],
              );
            } else {
              await initData();
            }
          }
        },
      );
}

typedef MyCollectedWebsiteProvider = AutoDisposeStateNotifierProvider<
    MyCollectedWebsiteNotifier, ListViewState<CollectedWebsiteModel>>;

typedef MyCollectedWebsiteProviderRef = AutoDisposeStateNotifierProviderRef<
    MyCollectedWebsiteNotifier, ListViewState<CollectedWebsiteModel>>;

final MyCollectedWebsiteProvider myCollectedWebsiteProvider =
    StateNotifierProvider.autoDispose<MyCollectedWebsiteNotifier,
        ListViewState<CollectedWebsiteModel>>(
  (MyCollectedWebsiteProviderRef ref) {
    final CancelToken cancelToken = ref.cancelToken();

    final Http http = ref.watch(networkProvider);

    return MyCollectedWebsiteNotifier(
      const ListViewState<CollectedWebsiteModel>.loading(),
      http: http,
      cancelToken: cancelToken,
    )..initData();
  },
  name: kMyCollectedWebsiteProvider,
);

class MyCollectedWebsiteNotifier
    extends BaseListViewNotifier<CollectedWebsiteModel> {
  MyCollectedWebsiteNotifier(
    super.state, {
    required this.http,
    this.cancelToken,
  });
  final Http http;

  final CancelToken? cancelToken;

  @override
  Future<List<CollectedWebsiteModel>> loadData() =>
      http.fetchCollectedWebsites();

  Future<CollectedWebsiteModel?> add({
    required String title,
    required String link,
    bool needLoading = true,
  }) async {
    try {
      if (needLoading) {
        DialogUtils.loading();
      }

      final CollectedWebsiteModel? data = await http.addCollectedWebsite(
        title: title,
        link: link,
      );

      if (data != null) {
        await initData();
      } else {
        DialogUtils.danger(S.current.failed);
      }

      return data;
    } on Exception catch (e, s) {
      DialogUtils.danger(ViewError.create(e, s).errorMessage(S.current.failed));

      return null;
    } finally {
      if (needLoading) {
        DialogUtils.dismiss();
      }
    }
  }

  Future<bool> update({
    required int collectId,
    required String title,
    required String link,
  }) async =>
      await state.whenOrNull<Future<bool>?>(
        (List<CollectedWebsiteModel> list) async {
          try {
            DialogUtils.loading();

            await http.updateCollectedWebsite(
              id: collectId,
              title: title,
              link: link,
            );

            state = ListViewStateData<CollectedWebsiteModel>(
              list: list
                  .map(
                    (CollectedWebsiteModel website) => website.id == collectId
                        ? website.copyWith(name: title, link: link)
                        : website,
                  )
                  .toList(),
            );

            return true;
          } on Exception catch (e, s) {
            DialogUtils.danger(
              ViewError.create(e, s).errorMessage(S.current.failed),
            );

            return false;
          } finally {
            DialogUtils.dismiss();
          }
        },
      ) ??
      false;

  Future<bool> requestCancelCollect({required int collectId}) async {
    try {
      await http.deleteCollectedWebsite(id: collectId);

      return true;
    } on Exception catch (e, s) {
      DialogUtils.danger(ViewError.create(e, s).errorMessage(S.current.failed));

      return false;
    }
  }

  void switchCollect(
    int id, {
    required bool changedValue,
    bool triggerCompleteCallback = false,
  }) {
    state.whenOrNull((List<CollectedWebsiteModel> list) {
      state = ListViewStateData<CollectedWebsiteModel>(
        list: list
            .map(
              (CollectedWebsiteModel collectedWebsite) =>
                  collectedWebsite.id == id
                      ? collectedWebsite.copyWith(collect: changedValue)
                      : collectedWebsite,
            )
            .toList(),
      );

      if (triggerCompleteCallback) {
        onSwitchCollectComplete();
      }
    });
  }

  void onSwitchCollectComplete() {
    state.whenOrNull((List<CollectedWebsiteModel> list) {
      if (list.none((CollectedWebsiteModel collect) => collect.collect)) {
        state = const ListViewStateData<CollectedWebsiteModel>(
          list: <CollectedWebsiteModel>[],
        );
      }
    });
  }
}

@riverpod
class HandleCollected extends _$HandleCollected {
  @override
  CollectedCommonModel? build({required CollectionType type, int? id}) {
    CollectedCommonModel? model;

    if (id == null) {
      return model;
    }

    switch (type) {
      case CollectionType.article:
        final CollectedArticleModel? articleModel = ref
            .read(myCollectedArticleProvider)
            .whenOrNull<CollectedArticleModel?>(
              (_, __, List<CollectedArticleModel> list) =>
                  list.firstWhereOrNull(
                (CollectedArticleModel article) => article.id == id,
              ),
            );

        if (articleModel != null) {
          model = CollectedCommonModel(
            id: articleModel.id,
            title: articleModel.title ?? '',
            author: articleModel.author ?? '',
            link: articleModel.link,
          );
        }
        break;
      case CollectionType.website:
        final CollectedWebsiteModel? websiteModel = ref
            .read(myCollectedWebsiteProvider)
            .whenOrNull<CollectedWebsiteModel?>(
              (List<CollectedWebsiteModel> list) => list.firstWhereOrNull(
                (CollectedWebsiteModel website) => website.id == id,
              ),
            );

        if (websiteModel != null) {
          model = CollectedCommonModel(
            id: websiteModel.id,
            title: websiteModel.name ?? '',
            link: websiteModel.link,
          );
        }
        break;
    }

    return model;
  }
}
