import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/error_interceptor.dart';
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
import '../../../utils/dialog_utils.dart';
import '../../drawer/provider/drawer_provider.dart'
    show
        MyCollectedArticleNotifier,
        MyCollectedWebsiteNotifier,
        kMyCollectedArticleProvider,
        kMyCollectedWebsiteProvider,
        kMyShareProvider;
import '../../home/provider/home_provider.dart';

const List<String> articles = <String>[
  kHomeArticleProvider,
  kSquareArticleProvider,
  kQuestionArticleProvider,
  kProjectArticleProvider,
];

const List<String> autoDisposeArticles = <String>[
  kSearchArticleProvider,
  kMyShareProvider,
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

  Map<String, ProviderBase<dynamic>> getProvidersJson() =>
      providerContainer.getAllProviderElements().fold(
        <String, ProviderBase<dynamic>>{},
        (
          Map<String, ProviderBase<dynamic>> previousValue,
          ProviderElementBase<dynamic> e,
        ) {
          if (allArticles.contains(e.provider.name)) {
            return <String, ProviderBase<dynamic>>{
              ...previousValue,
              e.provider.name!: e.provider,
            };
          }

          return previousValue;
        },
      );

  WebViewModel? findCollectedArticle(
    Map<String, ProviderBase<dynamic>> providers,
  ) {
    if (!providers.keys.contains(kMyCollectedArticleProvider)) {
      return null;
    }

    from = kMyCollectedArticleProvider;
    provider = providers[kMyCollectedArticleProvider]!;

    final CollectedArticleModel? collectedArticle =
        (reader.call(provider) as RefreshListViewState<CollectedArticleModel>)
            .whenOrNull((_, __, List<CollectedArticleModel> list) => list)
            ?.firstWhereOrNull((CollectedArticleModel e) => e.id == id);

    if (collectedArticle != null) {
      if (collectedArticle.originId != null) {
        for (final String key in providers.keys) {
          if (<String>[...articles, ...autoDisposeArticles].contains(key)) {
            articleOrigin.add(key);
            articleOriginProvider.add(providers[key]!);
          }
        }
      }

      return WebViewModel(
        id: collectedArticle.id,
        link: collectedArticle.link.startsWith('http')
            ? collectedArticle.link
            : 'https://${collectedArticle.link}',
        originId: collectedArticle.originId,
        title: collectedArticle.title,
        collect: collectedArticle.collect,
      );
    }

    return null;
  }

  Future<void> collectCollectedArticle(
    WebViewModel webView, {
    required bool value,
  }) async {
    final AutoDisposeStateNotifierProvider<MyCollectedWebsiteNotifier,
            ListViewState<CollectedWebsiteModel>> realProvider =
        provider as AutoDisposeStateNotifierProvider<MyCollectedWebsiteNotifier,
            ListViewState<CollectedWebsiteModel>>;
    if (value) {
      final CollectedWebsiteModel? newCollectedWebsite =
          await reader.call(realProvider.notifier).add(
                title: webView.title ?? '',
                link: webView.link,
                needLoading: false,
              );

      if (newCollectedWebsite != null) {
        state = ViewStateData<WebViewModel>(
          value: webView.copyWith(
            id: newCollectedWebsite.id,
            collect: true,
          ),
        );
      }
    } else {
      await reader
          .call(realProvider.notifier)
          .requestCancelCollect(collectId: webView.id);
    }

    reader.call(realProvider.notifier).switchCollect(
          id,
          changedValue: value,
        );
  }

  /// [kMyCollectedArticleProvider] and [kMyCollectedWebsiteProvider] is
  /// autoDispose provider, So if they exist, it can be considered to be
  /// currently in the [MyCollectionsScreen]
  /// that is, they can be searched first from them
  WebViewModel? findCollectedWebsite(
    Map<String, ProviderBase<dynamic>> providers,
  ) {
    if (!providers.keys.contains(kMyCollectedArticleProvider) &&
        !providers.keys.contains(kMyCollectedWebsiteProvider)) {
      return null;
    }

    from = kMyCollectedWebsiteProvider;
    provider = providers[kMyCollectedWebsiteProvider]!;

    final CollectedWebsiteModel? collectedWebsite =
        (reader.call(provider) as ListViewState<CollectedWebsiteModel>)
            .whenOrNull((List<CollectedWebsiteModel> list) => list)
            ?.firstWhereOrNull((CollectedWebsiteModel e) => e.id == id);

    if (collectedWebsite != null) {
      return WebViewModel(
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
    }

    return null;
  }

  Future<void> collectCollectedWebsite(
    WebViewModel webView, {
    required bool value,
  }) async {
    final AutoDisposeStateNotifierProvider<MyCollectedArticleNotifier,
            RefreshListViewState<CollectedArticleModel>> realProvider =
        provider as AutoDisposeStateNotifierProvider<MyCollectedArticleNotifier,
            RefreshListViewState<CollectedArticleModel>>;
    if (value) {
      await WanAndroidAPI.addCollectedArticleByArticleId(
        articleId: id,
      );
    } else {
      reader.call(realProvider.notifier).requestCancelCollect(
            collectId: id,
            articleId: webView.originId,
          );
    }
    reader.call(realProvider.notifier).switchCollect(
          id,
          changedValue: value,
        );

    if (articleOrigin.isNotEmpty) {
      for (int index = 0; index < articleOrigin.length; index++) {
        if (autoDisposeArticles.contains(articleOrigin[index])) {
          reader
              .call((articleOriginProvider[index]
                      as AutoDisposeStateNotifierProvider<BaseArticleNotifier,
                          RefreshListViewState<ArticleModel>>)
                  .notifier)
              .switchCollect(
                webView.originId!,
                changedValue: value,
              );
        } else {
          reader
              .call((articleOriginProvider[index] as StateNotifierProvider<
                      BaseArticleNotifier, RefreshListViewState<ArticleModel>>)
                  .notifier)
              .switchCollect(
                webView.originId!,
                changedValue: value,
              );
        }
      }
    }
  }

  WebViewModel? findArticle(
    Map<String, ProviderBase<dynamic>> providers,
  ) {
    for (final String key in providers.keys) {
      if (<String>[...articles, ...autoDisposeArticles].contains(key)) {
        from = key;
        provider = providers[key]!;
        final ArticleModel? article =
            (reader.call(provider) as RefreshListViewState<ArticleModel>)
                .whenOrNull((_, __, List<ArticleModel> list) => list)
                ?.firstWhereOrNull((ArticleModel e) => e.id == id);

        if (article != null) {
          return WebViewModel(
            id: article.id,
            link: article.link,
            title: article.title,
            collect: article.collect,
          );
        }
      }
    }

    return null;
  }

  Future<void> collectArticle({
    required bool value,
  }) async {
    if (value) {
      await WanAndroidAPI.addCollectedArticleByArticleId(articleId: id);
    } else {
      await WanAndroidAPI.deleteCollectedArticleByArticleId(
        articleId: id,
      );
    }

    if (autoDisposeArticles.contains(from)) {
      reader
          .call((provider as AutoDisposeStateNotifierProvider<
                  BaseArticleNotifier, RefreshListViewState<ArticleModel>>)
              .notifier)
          .switchCollect(
            id,
            changedValue: value,
          );
    } else {
      reader
          .call((provider as StateNotifierProvider<BaseArticleNotifier,
                  RefreshListViewState<ArticleModel>>)
              .notifier)
          .switchCollect(
            id,
            changedValue: value,
          );
    }
  }

  @override
  Future<WebViewModel?> loadData() async {
    final Map<String, ProviderBase<dynamic>> providers = getProvidersJson();

    final WebViewModel? webViewModel = findCollectedWebsite(providers) ??
        findCollectedArticle(providers) ??
        findArticle(providers);

    if (webViewModel != null) {
      return webViewModel;
    } else {
      throw AppException(
        errorCode: 404,
        message: S.current.articleNotFound,
        detail: S.current.articleNotFoundMsg,
      );
    }
  }

  void collect(bool value) {
    state.whenOrNull((WebViewModel? webView) async {
      if (webView != null) {
        state = ViewStateData<WebViewModel>(
          value: webView.copyWith(
            collect: value,
          ),
        );
        try {
          if (webView.originId != null) {
            /// from MyCollectionsScreen
            if (webView.originId == -2) {
              /// from MyCollectionsScreen - website
              await collectCollectedWebsite(webView, value: value);
            } else {
              /// from MyCollectionsScreen - article
              await collectCollectedArticle(webView, value: value);
            }
          } else {
            /// from other article screen
            /// eg. HomeArticleScreen, SearchScreen
            await collectArticle(value: value);
          }
        } catch (e, s) {
          DialogUtils.danger(getError(e, s).message ?? S.current.failed);
        }
      }
    });
  }
}
