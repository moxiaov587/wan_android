part of 'drawer_provider.dart';

const List<String> articles = <String>[
  kHomeArticleProvider,
  kSquareArticleProvider,
  kQuestionArticleProvider,
  kProjectArticleProvider,
];

const String kMyCollectedArticleProvider = 'kMyCollectedArticleProvider';
const String kMyCollectedWebsiteProvider = 'kMyCollectedWebsiteProvider';

final AutoDisposeStateNotifierProvider<MyCollectedArticleNotifier,
        RefreshListViewState<CollectedArticleModel>>
    myCollectedArticleProvider = StateNotifierProvider.autoDispose<
        MyCollectedArticleNotifier,
        RefreshListViewState<CollectedArticleModel>>(
  (AutoDisposeStateNotifierProviderRef<MyCollectedArticleNotifier,
          RefreshListViewState<CollectedArticleModel>>
      ref) {
    final CancelToken cancelToken = CancelToken();

    ref.onDispose(() {
      cancelToken.cancel();
    });

    return MyCollectedArticleNotifier(
      const RefreshListViewState<CollectedArticleModel>.loading(),
      reader: ref.read,
      providerContainer: ref.container,
      cancelToken: cancelToken,
    );
  },
  name: kMyCollectedArticleProvider,
);

class MyCollectedArticleNotifier
    extends BaseRefreshListViewNotifier<CollectedArticleModel> {
  MyCollectedArticleNotifier(
    super.state, {
    required this.reader,
    required this.providerContainer,
    this.cancelToken,
  }) : super(
          initialPageNum: 0,
        );

  final Reader reader;
  final ProviderContainer providerContainer;

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<CollectedArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await WanAndroidAPI.fetchCollectedArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }

  Future<bool> add({
    required String title,
    required String author,
    required String link,
  }) async {
    try {
      DialogUtils.loading();

      final CollectedArticleModel? data =
          await WanAndroidAPI.addCollectedArticle(
        title: title,
        author: author,
        link: link,
      );

      if (data != null) {
        initData();

        return true;
      } else {
        DialogUtils.danger(S.current.failed);

        return false;
      }
    } catch (e, s) {
      DialogUtils.danger(getError(e, s).message ?? S.current.failed);

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
  }) async {
    return await state.whenOrNull<Future<bool>?>((
          int pageNum,
          bool isLastPage,
          List<CollectedArticleModel> list,
        ) async {
          try {
            DialogUtils.loading();

            await WanAndroidAPI.updateCollectedArticle(
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
          } catch (e, s) {
            DialogUtils.danger(getError(e, s).message ?? S.current.failed);

            return false;
          } finally {
            DialogUtils.dismiss();
          }
        }) ??
        false;
  }

  Future<bool> requestCancelCollect({
    required int collectId,
    required int? articleId,
  }) async {
    try {
      await WanAndroidAPI.deleteCollectedArticleByCollectId(
        collectId: collectId,
        articleId: articleId,
      );

      return true;
    } catch (e, s) {
      DialogUtils.danger(getError(e, s).message ?? S.current.failed);

      return false;
    }
  }

  void switchOtherArticleCollect(
    int id, {
    required bool changedValue,
  }) {
    final Map<String, ProviderBase<dynamic>> providers =
        providerContainer.getAllProviderElements().fold(
      <String, ProviderBase<dynamic>>{},
      (
        Map<String, ProviderBase<dynamic>> previousValue,
        ProviderElementBase<dynamic> e,
      ) {
        if (articles.contains(e.provider.name)) {
          return <String, ProviderBase<dynamic>>{
            ...previousValue,
            e.provider.name!: e.provider,
          };
        }

        return previousValue;
      },
    );

    late ProviderBase<dynamic> provider;

    ArticleModel? article;

    for (final String key in providers.keys) {
      if (articles.contains(key)) {
        provider = providers[key]!;
        article = (reader.call(provider) as RefreshListViewState<ArticleModel>)
            .whenOrNull((_, __, List<ArticleModel> list) => list)
            ?.firstWhereOrNull((ArticleModel e) => e.id == id);

        if (article != null) {
          break;
        }
      }
    }

    if (article != null) {
      reader
          .call((provider as StateNotifierProvider<BaseArticleNotifier,
                  RefreshListViewState<ArticleModel>>)
              .notifier)
          .switchCollect(
            id,
            changedValue: changedValue,
          );
    }
  }

  void switchCollect(
    int id, {
    required bool changedValue,
  }) {
    state.whenOrNull(
      (
        int pageNum,
        bool isLastPage,
        List<CollectedArticleModel> list,
      ) {
        /// If it is not null, it means to collect from the article.
        /// Need to check whether the article exists in the home tabs provider.
        /// If there is a collection status that needs to be synchronized
        int? originId;
        final List<CollectedArticleModel> changedList =
            list.map((CollectedArticleModel collectedArticle) {
          if (collectedArticle.id == id) {
            originId = collectedArticle.originId;

            return collectedArticle.copyWith(
              collect: changedValue,
            );
          }

          return collectedArticle;
        }).toList();
        state = RefreshListViewStateData<CollectedArticleModel>(
          pageNum: pageNum,
          isLastPage: isLastPage,
          list: changedList,
        );

        if (changedList.firstWhereOrNull(
              (CollectedArticleModel collect) => collect.collect,
            ) ==
            null) {
          if (isLastPage) {
            Future<void>.delayed(Duration.zero, () {
              state = RefreshListViewStateData<CollectedArticleModel>(
                pageNum: pageNum,
                isLastPage: isLastPage,
                list: <CollectedArticleModel>[],
              );
            });
          } else {
            initData();
          }
        }

        if (originId != null) {
          switchOtherArticleCollect(
            originId!,
            changedValue: changedValue,
          );
        }
      },
    );
  }
}

final AutoDisposeStateNotifierProvider<MyCollectedWebsiteNotifier,
        ListViewState<CollectedWebsiteModel>> myCollectedWebsiteProvider =
    StateNotifierProvider.autoDispose<MyCollectedWebsiteNotifier,
        ListViewState<CollectedWebsiteModel>>(
  (AutoDisposeStateNotifierProviderRef<MyCollectedWebsiteNotifier,
          ListViewState<CollectedWebsiteModel>>
      ref) {
    final CancelToken cancelToken = CancelToken();

    ref.onDispose(() {
      cancelToken.cancel();
    });

    return MyCollectedWebsiteNotifier(
      const ListViewState<CollectedWebsiteModel>.loading(),
      cancelToken: cancelToken,
    );
  },
  name: kMyCollectedWebsiteProvider,
);

class MyCollectedWebsiteNotifier
    extends BaseListViewNotifier<CollectedWebsiteModel> {
  MyCollectedWebsiteNotifier(
    super.state, {
    this.cancelToken,
  });

  final CancelToken? cancelToken;

  @override
  Future<List<CollectedWebsiteModel>> loadData() {
    return WanAndroidAPI.fetchCollectedWebsites();
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

      final CollectedWebsiteModel? data =
          await WanAndroidAPI.addCollectedWebsite(
        title: title,
        link: link,
      );

      if (data != null) {
        initData();
      } else {
        DialogUtils.danger(S.current.failed);
      }

      return data;
    } catch (e, s) {
      DialogUtils.danger(getError(e, s).message ?? S.current.failed);

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
  }) async {
    return await state.whenOrNull<Future<bool>?>(
          (List<CollectedWebsiteModel> list) async {
            try {
              DialogUtils.loading();

              await WanAndroidAPI.updateCollectedWebsite(
                id: collectId,
                title: title,
                link: link,
              );

              state = ListViewStateData<CollectedWebsiteModel>(
                list: list
                    .map(
                      (CollectedWebsiteModel website) => website.id == collectId
                          ? website.copyWith(
                              name: title,
                              link: link,
                            )
                          : website,
                    )
                    .toList(),
              );

              return true;
            } catch (e, s) {
              DialogUtils.danger(getError(e, s).message ?? S.current.failed);

              return false;
            } finally {
              DialogUtils.dismiss();
            }
          },
        ) ??
        false;
  }

  Future<bool> requestCancelCollect({
    required int collectId,
  }) async {
    try {
      await WanAndroidAPI.deleteCollectedWebsite(
        id: collectId,
      );

      return true;
    } catch (e, s) {
      DialogUtils.danger(getError(e, s).message ?? S.current.failed);

      return false;
    }
  }

  void switchCollect(
    int id, {
    required bool changedValue,
  }) {
    state.whenOrNull((List<CollectedWebsiteModel> list) {
      final List<CollectedWebsiteModel> changedList = list
          .map((CollectedWebsiteModel collectedWebsite) =>
              collectedWebsite.id == id
                  ? collectedWebsite.copyWith(
                      collect: changedValue,
                    )
                  : collectedWebsite)
          .toList();
      state = ListViewStateData<CollectedWebsiteModel>(
        list: changedList,
      );

      if (changedList.firstWhereOrNull(
            (CollectedWebsiteModel collect) => collect.collect,
          ) ==
          null) {
        Future<void>.delayed(Duration.zero, () {
          state = const ListViewStateData<CollectedWebsiteModel>(
            list: <CollectedWebsiteModel>[],
          );
        });
      }
    });
  }
}

class CollectionTypeModel {
  const CollectionTypeModel({
    required this.type,
    required this.id,
  });

  final CollectionType type;
  final int? id;
}

final AutoDisposeStateNotifierProviderFamily<CollectedNotifier,
        ViewState<CollectedCommonModel>, CollectionTypeModel>
    collectedModelProvider = StateNotifierProvider.autoDispose.family<
        CollectedNotifier,
        ViewState<CollectedCommonModel>,
        CollectionTypeModel>((
  AutoDisposeStateNotifierProviderRef<CollectedNotifier,
          ViewState<CollectedCommonModel>>
      ref,
  CollectionTypeModel typeModel,
) {
  return CollectedNotifier(
    const ViewState<CollectedCommonModel>.loading(),
    reader: ref.read,
    typeModel: typeModel,
  );
});

class CollectedNotifier extends BaseViewNotifier<CollectedCommonModel> {
  CollectedNotifier(
    super.state, {
    required this.reader,
    required this.typeModel,
  });

  final Reader reader;
  final CollectionTypeModel typeModel;

  @override
  Future<CollectedCommonModel?> loadData() async {
    CollectedCommonModel? model;

    if (typeModel.id == null) {
      return model;
    }

    switch (typeModel.type) {
      case CollectionType.article:
        final CollectedArticleModel? articleModel = reader
            .call(myCollectedArticleProvider)
            .whenOrNull<CollectedArticleModel?>(
              (_, __, List<CollectedArticleModel> list) =>
                  list.firstWhereOrNull((CollectedArticleModel article) =>
                      article.id == typeModel.id),
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
        final CollectedWebsiteModel? websiteModel = reader
            .call(myCollectedWebsiteProvider)
            .whenOrNull<CollectedWebsiteModel?>(
              (List<CollectedWebsiteModel> list) => list.firstWhereOrNull(
                (CollectedWebsiteModel website) => website.id == typeModel.id,
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
