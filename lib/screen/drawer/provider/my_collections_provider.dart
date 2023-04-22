part of 'drawer_provider.dart';

@riverpod
class MyCollectedArticle extends _$MyCollectedArticle
    with LoadMoreMixin<CollectedArticleModel> {
  late Http _http;

  @override
  Future<PaginationData<CollectedArticleModel>> build({
    int pageNum = 0,
    int pageSize = kDefaultPageSize,
  }) async {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    final PaginationData<CollectedArticleModel> data =
        await _http.fetchCollectedArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    );

    if (pageNum == 0) {
      return data.copyWith(
        curPage: 0, // Fix curPage.
      );
    }

    return data;
  }

  @override
  Future<PaginationData<CollectedArticleModel>> buildMore(
    int pageNum,
    int pageSize,
  ) =>
      build(pageNum: pageNum, pageSize: pageSize);

  Future<bool> add({
    required String title,
    required String author,
    required String link,
  }) async {
    try {
      DialogUtils.loading();

      final CollectedArticleModel? data = await _http.addCollectedArticle(
        title: title,
        author: author,
        link: link,
      );

      if (data != null) {
        ref.invalidateSelf();

        return true;
      } else {
        DialogUtils.danger(S.current.failed);

        return false;
      }
    } on Exception catch (e, s) {
      DialogUtils.danger(
        AppException.create(e, s).errorMessage(S.current.failed),
      );

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }

  Future<bool> edit({
    required int collectId,
    required String title,
    required String author,
    required String link,
  }) =>
      state.whenOrNull<Future<bool>>(
        data: (PaginationData<CollectedArticleModel> data) async {
          final int index = data.datas
              .indexWhere((CollectedArticleModel e) => e.id == collectId);

          if (index == -1) {
            return false;
          }

          try {
            DialogUtils.loading();

            await _http.updateCollectedArticle(
              id: collectId,
              title: title,
              author: author,
              link: link,
            );

            state = AsyncData<PaginationData<CollectedArticleModel>>(
              data.copyWith(
                datas: data.datas
                  ..setAll(index, <CollectedArticleModel>[
                    data.datas.elementAt(index).copyWith(
                          title: title,
                          author: author,
                          link: link,
                        ),
                  ]),
              ),
            );

            return true;
          } on Exception catch (e, s) {
            DialogUtils.danger(
              AppException.create(e, s).errorMessage(S.current.failed),
            );

            return false;
          } finally {
            DialogUtils.dismiss();
          }
        },
      ) ??
      Future<bool>.value(false);

  Future<bool> requestCancelCollect({
    required int collectId,
    required int? articleId,
  }) async {
    try {
      await _http.deleteCollectedArticleByCollectId(
        collectId: collectId,
        articleId: articleId,
      );

      return true;
    } on Exception catch (e, s) {
      DialogUtils.danger(
        AppException.create(e, s).errorMessage(S.current.failed),
      );

      return false;
    }
  }

  void switchCollect(
    int index, {
    required bool changedValue,
    bool triggerCompleteCallback = false,
  }) =>
      state.whenOrNull(
        data: (PaginationData<CollectedArticleModel> data) {
          if (index == -1) {
            return;
          }

          state = AsyncData<PaginationData<CollectedArticleModel>>(
            data.copyWith(
              datas: data.datas
                ..setAll(
                  index,
                  <CollectedArticleModel>[
                    data.datas[index].copyWith(collect: changedValue)
                  ],
                ),
            ),
          );

          if (triggerCompleteCallback) {
            onSwitchCollectComplete();
          }
        },
      );

  void onSwitchCollectComplete() => state.whenOrNull(
        data: (PaginationData<CollectedArticleModel> data) {
          if (data.datas
              .none((CollectedArticleModel collect) => collect.collect)) {
            if (data.over) {
              state = AsyncData<PaginationData<CollectedArticleModel>>(
                data.copyWith(datas: <CollectedArticleModel>[]),
              );
            } else {
              ref.invalidateSelf();
            }
          }
        },
      );
}

typedef MyCollectedWebsiteProvider = AutoDisposeAsyncNotifierProvider<
    MyCollectedWebsite, List<CollectedWebsiteModel>>;

@riverpod
class MyCollectedWebsite extends _$MyCollectedWebsite {
  late Http _http;

  @override
  Future<List<CollectedWebsiteModel>> build() {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    return _http.fetchCollectedWebsites(cancelToken: cancelToken);
  }

  Future<CollectedWebsiteModel?> add({
    required String title,
    required String link,
    bool needLoading = true,
  }) async {
    try {
      if (needLoading) {
        DialogUtils.loading();
      }

      final CollectedWebsiteModel? data = await _http.addCollectedWebsite(
        title: title,
        link: link,
      );

      if (data != null) {
        ref.invalidateSelf();
      } else {
        DialogUtils.danger(S.current.failed);
      }

      return data;
    } on Exception catch (e, s) {
      DialogUtils.danger(
        AppException.create(e, s).errorMessage(S.current.failed),
      );

      return null;
    } finally {
      if (needLoading) {
        DialogUtils.dismiss();
      }
    }
  }

  Future<bool> edit({
    required int collectId,
    required String title,
    required String link,
  }) =>
      state.whenOrNull<Future<bool>>(
        data: (List<CollectedWebsiteModel> list) async {
          final int index =
              list.indexWhere((CollectedWebsiteModel e) => e.id == collectId);

          if (index == -1) {
            return false;
          }

          try {
            DialogUtils.loading();

            await _http.updateCollectedWebsite(
              id: collectId,
              title: title,
              link: link,
            );

            state = AsyncData<List<CollectedWebsiteModel>>(
              list
                ..setAll(index, <CollectedWebsiteModel>[
                  list.elementAt(index).copyWith(name: title, link: link),
                ]),
            );

            return true;
          } on Exception catch (e, s) {
            DialogUtils.danger(
              AppException.create(e, s).errorMessage(S.current.failed),
            );

            return false;
          } finally {
            DialogUtils.dismiss();
          }
        },
      ) ??
      Future<bool>.value(false);

  Future<bool> requestCancelCollect({required int collectId}) async {
    try {
      await _http.deleteCollectedWebsite(id: collectId);

      return true;
    } on Exception catch (e, s) {
      DialogUtils.danger(
        AppException.create(e, s).errorMessage(S.current.failed),
      );

      return false;
    }
  }

  void switchCollect(
    int index, {
    required bool changedValue,
    bool triggerCompleteCallback = false,
  }) {
    state.whenOrNull(
      data: (List<CollectedWebsiteModel> list) {
        if (index == -1) {
          return;
        }

        state = AsyncData<List<CollectedWebsiteModel>>(
          list
            ..setAll(
              index,
              <CollectedWebsiteModel>[
                list[index].copyWith(collect: changedValue)
              ],
            ),
        );

        if (triggerCompleteCallback) {
          onSwitchCollectComplete();
        }
      },
    );
  }

  void onSwitchCollectComplete() {
    state.whenOrNull(
      data: (List<CollectedWebsiteModel> list) {
        if (list.none((CollectedWebsiteModel collect) => collect.collect)) {
          state = const AsyncData<List<CollectedWebsiteModel>>(
            <CollectedWebsiteModel>[],
          );
        }
      },
    );
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
            .read(myCollectedArticleProvider())
            .whenOrNull<CollectedArticleModel?>(
              data: (PaginationData<CollectedArticleModel> data) =>
                  data.datas.firstWhereOrNull(
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
              data: (List<CollectedWebsiteModel> list) => list.firstWhereOrNull(
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
