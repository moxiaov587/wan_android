import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/error_interceptors.dart';
import '../../../app/http/wan_android_api.dart';
import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/provider.dart';
import '../../../app/provider/view_state.dart';
import '../../../model/models.dart'
    show
        ArticleModel,
        CollectedArticleModel,
        CollectedWebsiteModel,
        WebViewModel;
import '../../../utils/dialog.dart';
import '../../drawer/provider/drawer_provider.dart'
    show
        MyCollectedArticleNotifier,
        MyCollectedWebsiteNotifier,
        kMyCollectedArticleProvider,
        kMyCollectedWebsiteProvider;
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
  kMyCollectedArticleProvider,
  kMyCollectedWebsiteProvider,
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

    CollectedArticleModel? collectedArticle;
    CollectedWebsiteModel? collectedWebsite;

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

    if (providers.keys.contains(kMyCollectedArticleProvider)) {
      if (providers.keys.contains(kMyCollectedWebsiteProvider)) {
        from = kMyCollectedWebsiteProvider;
        provider = providers[kMyCollectedWebsiteProvider]!;

        collectedWebsite =
            (reader.call(provider) as ListViewState<CollectedWebsiteModel>)
                .whenOrNull((List<CollectedWebsiteModel> list) => list)
                ?.firstWhereOrNull((CollectedWebsiteModel e) => e.id == id);
      } else {
        from = kMyCollectedArticleProvider;
        provider = providers[kMyCollectedArticleProvider]!;

        collectedArticle = (reader.call(provider)
                as RefreshListViewState<CollectedArticleModel>)
            .whenOrNull((_, __, List<CollectedArticleModel> list) => list)
            ?.firstWhereOrNull((CollectedArticleModel e) => e.id == id);
      }
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

    if (collectedArticle != null) {
      webViewModel = WebViewModel(
        id: collectedArticle.id,
        link: collectedArticle.link.startsWith('http')
            ? collectedArticle.link
            : 'https://${collectedArticle.link}',
        originId: collectedArticle.originId,
        title: collectedArticle.title,
        collect: collectedArticle.collect,
      );

      if (collectedArticle.originId != null) {
        for (final String key in providers.keys) {
          if (<String>[...articles, ...autoDisposeArticles].contains(key)) {
            articleOrigin.add(key);
            articleOriginProvider.add(providers[key]!);
          }
        }
      }
    } else if (collectedWebsite != null) {
      webViewModel = WebViewModel(
        id: collectedWebsite.id,
        link: collectedWebsite.link.startsWith('http')
            ? collectedWebsite.link
            : 'https://${collectedWebsite.link}',

        /// Use -2 as the logo of collected sites
        /// because -1 has a role in collected articles :)
        originId: -2,
        title: collectedWebsite.name,
        collect: collectedWebsite.collect,
      );
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

  void collect(bool collected) {
    state.whenOrNull((WebViewModel? value) async {
      if (value != null) {
        state = ViewStateData<WebViewModel>(
          value: value.copyWith(
            collect: collected,
          ),
        );
        try {
          if (value.originId != null) {
            /// from MyCollectionsScreen
            if (value.originId == -2) {
              /// from MyCollectionsScreen - website
              final AutoDisposeStateNotifierProvider<MyCollectedWebsiteNotifier,
                      ListViewState<CollectedWebsiteModel>> realProvider =
                  provider as AutoDisposeStateNotifierProvider<
                      MyCollectedWebsiteNotifier,
                      ListViewState<CollectedWebsiteModel>>;
              if (collected) {
                final CollectedWebsiteModel? newCollectedWebsite =
                    await reader.call(realProvider.notifier).add(
                          title: value.title ?? '',
                          link: value.link,
                          needLoading: false,
                        );

                if (newCollectedWebsite != null) {
                  state = ViewStateData<WebViewModel>(
                    value: value.copyWith(
                      id: newCollectedWebsite.id,
                      collect: true,
                    ),
                  );
                }
              } else {
                await reader
                    .call(realProvider.notifier)
                    .requestCancelCollect(collectId: value.id);
              }

              reader.call(realProvider.notifier).switchCollected(
                    id,
                    collected: collected,
                  );
            } else {
              /// from MyCollectionsScreen - article
              final AutoDisposeStateNotifierProvider<MyCollectedArticleNotifier,
                      RefreshListViewState<CollectedArticleModel>>
                  realProvider = provider as AutoDisposeStateNotifierProvider<
                      MyCollectedArticleNotifier,
                      RefreshListViewState<CollectedArticleModel>>;
              if (collected) {
                await WanAndroidAPI.addCollectedArticleByArticleId(
                    articleId: id);
              } else {
                reader.call(realProvider.notifier).requestCancelCollect(
                      collectId: id,
                      articleId: value.originId,
                    );
              }
              reader.call(realProvider.notifier).switchCollected(
                    id,
                    collected: collected,
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
                          collected: collected,
                        );
                  } else {
                    reader
                        .call((articleOriginProvider[index]
                                as StateNotifierProvider<BaseArticleNotifier,
                                    RefreshListViewState<ArticleModel>>)
                            .notifier)
                        .switchCollected(
                          value.originId!,
                          collected: collected,
                        );
                  }
                }
              }
            }
          } else {
            /// from other article screen
            /// eg. HomeArticleScreen, SearchScreen
            if (collected) {
              await WanAndroidAPI.addCollectedArticleByArticleId(articleId: id);
            } else {
              await WanAndroidAPI.deleteCollectedArticleByArticleId(
                  articleId: id);
            }

            if (autoDisposeArticles.contains(from)) {
              reader
                  .call((provider as AutoDisposeStateNotifierProvider<
                          BaseArticleNotifier,
                          RefreshListViewState<ArticleModel>>)
                      .notifier)
                  .switchCollected(
                    id,
                    collected: collected,
                  );
            } else {
              reader
                  .call((provider as StateNotifierProvider<BaseArticleNotifier,
                          RefreshListViewState<ArticleModel>>)
                      .notifier)
                  .switchCollected(
                    id,
                    collected: collected,
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
