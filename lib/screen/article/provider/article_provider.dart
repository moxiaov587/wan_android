import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/error_interceptors.dart';
import '../../../app/http/wan_android_api.dart';
import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/provider.dart';
import '../../../app/provider/view_state.dart';
import '../../../model/models.dart'
    show ArticleModel, CollectModel, WebViewModel;
import '../../../utils/dialog.dart';
import '../../drawer/provider/drawer_provider.dart'
    show MyCollectionsNotifier, kMyCollectionsProvider;
import '../../home/provider/home_provider.dart';

enum ArticleFrom {
  home,
  square,
  question,
  project,
  search,
  myCollections,
}

const List<String> articles = <String>[
  kHomeArticleProvider,
  kSquareArticleProvider,
  kQuestionArticleProvider,
  kProjectArticleProvider,
];

const List<String> autoDisposeArticles = <String>[
  kSearchArticleProvider,
];

const List<String> collects = <String>[
  kMyCollectionsProvider,
];

const List<String> allArticles = <String>[
  ...articles,
  ...autoDisposeArticles,
  ...collects,
];

final AutoDisposeStateNotifierProviderFamily<ArticleNotifier,
        ViewState<WebViewModel>, int> articleProvider =
    StateNotifierProvider.autoDispose
        .family<ArticleNotifier, ViewState<WebViewModel>, int>((
  AutoDisposeStateNotifierProviderRef<ArticleNotifier, ViewState<WebViewModel>>
      ref,
  int articleId,
) {
  return ArticleNotifier(
    reader: ref.read,
    providerContainer: ref.container,
    id: articleId,
  );
});

class ArticleNotifier extends BaseViewNotifier<WebViewModel> {
  ArticleNotifier({
    required this.reader,
    required this.providerContainer,
    required this.id,
  }) : super(const ViewState<WebViewModel>.loading());

  final Reader reader;
  final ProviderContainer providerContainer;
  final int id;

  late String from;
  late ProviderBase<dynamic> provider;

  final List<String> articleOrigin = <String>[];
  final List<ProviderBase<dynamic>> articleOriginProvider =
      <ProviderBase<dynamic>>[];

  @override
  Future<WebViewModel?> loadData() async {
    late WebViewModel webViewModel;

    CollectModel? collect;

    ArticleModel? article;

    final Map<String, ProviderBase<dynamic>> providers = providerContainer
        .getAllProviderElements()
        .fold(<String, ProviderBase<dynamic>>{},
            (Map<String, ProviderBase<dynamic>> previousValue,
                ProviderElementBase<dynamic> e) {
      if (allArticles.contains(e.provider.name)) {
        return <String, ProviderBase<dynamic>>{
          ...previousValue,
          e.provider.name!: e.provider,
        };
      }
      return previousValue;
    });

    if (providers.keys.contains(kMyCollectionsProvider)) {
      from = kMyCollectionsProvider;
      provider = providers[kMyCollectionsProvider]!;

      collect = (reader.call(provider) as RefreshListViewState<CollectModel>)
          .whenOrNull((_, __, List<CollectModel> list) => list)
          ?.firstWhereOrNull((CollectModel e) => e.id == id);
    } else {
      for (final String key in providers.keys) {
        if (<String>[...articles, ...autoDisposeArticles].contains(key)) {
          from = key;
          provider = providers[key]!;
          article =
              (reader.call(provider) as RefreshListViewState<ArticleModel>)
                  .whenOrNull((_, __, List<ArticleModel> list) => list)
                  ?.firstWhereOrNull((ArticleModel e) => e.id == id);

          if (article != null) {
            break;
          }
        }
      }
    }

    if (collect != null) {
      webViewModel = WebViewModel(
        id: collect.id,
        link: collect.link,
        originId: collect.originId,
        title: collect.title,
        collect: collect.collect,
      );

      if (collect.originId != null) {
        for (final String key in providers.keys) {
          if (<String>[...articles, ...autoDisposeArticles].contains(key)) {
            articleOrigin.add(key);
            articleOriginProvider.add(providers[key]!);
          }
        }
      }
    } else if (article != null) {
      webViewModel = WebViewModel(
        id: article.id,
        link: article.link,
        title: article.title,
        collect: article.collect,
      );
    } else {
      throw AppException(
        errorCode: 404,
        message: S.current.articleNotFound,
        detail: S.current.articleNotFoundMsg,
      );
    }

    return webViewModel;
  }

  void collect(bool isCollected) {
    state.whenOrNull((WebViewModel? value) async {
      if (value != null) {
        state = ViewStateData<WebViewModel>(
          value: value.copyWith(
            collect: isCollected,
          ),
        );
        try {
          if (value.originId != null) {
            /// in MyCollectionsScreen
            if (isCollected) {
              await WanAndroidAPI.collectArticle(articleId: id);
            } else {
              await WanAndroidAPI.cancelCollectionArticleByCollectId(
                collectId: id,
                articleId: value.originId,
              );
            }
            reader
                .call((provider as AutoDisposeStateNotifierProvider<
                        MyCollectionsNotifier,
                        RefreshListViewState<CollectModel>>)
                    .notifier)
                .toggleCollected(
                  id,
                  isCollected: isCollected,
                );

            if (articleOrigin.isNotEmpty) {
              for (int index = 0; index < articleOrigin.length; index++) {
                if (autoDisposeArticles.contains(articleOrigin[index])) {
                  reader
                      .call((articleOriginProvider[index]
                              as AutoDisposeStateNotifierProvider<
                                  BaseArticleNotifier,
                                  RefreshListViewState<ArticleModel>>)
                          .notifier)
                      .switchCollected(
                        value.originId!,
                        isCollected: isCollected,
                      );
                } else {
                  reader
                      .call((articleOriginProvider[index]
                              as StateNotifierProvider<BaseArticleNotifier,
                                  RefreshListViewState<ArticleModel>>)
                          .notifier)
                      .switchCollected(
                        value.originId!,
                        isCollected: isCollected,
                      );
                }
              }
            }
          } else {
            /// in other article screen
            if (isCollected) {
              await WanAndroidAPI.collectArticle(articleId: id);
            } else {
              await WanAndroidAPI.cancelCollectionArticle(articleId: id);
            }

            if (autoDisposeArticles.contains(from)) {
              reader
                  .call((provider as AutoDisposeStateNotifierProvider<
                          BaseArticleNotifier,
                          RefreshListViewState<ArticleModel>>)
                      .notifier)
                  .switchCollected(
                    id,
                    isCollected: isCollected,
                  );
            } else {
              reader
                  .call((provider as StateNotifierProvider<BaseArticleNotifier,
                          RefreshListViewState<ArticleModel>>)
                      .notifier)
                  .switchCollected(
                    id,
                    isCollected: isCollected,
                  );
            }
          }
        } catch (e, s) {
          final String? message = getError(e, s).message;

          if (message != null) {
            DialogUtils.danger(message);
          }
        }
      }
    });
  }
}
