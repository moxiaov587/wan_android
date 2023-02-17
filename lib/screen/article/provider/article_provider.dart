import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/http/http.dart';
import '../../../app/http/interceptors/interceptors.dart' show AppException;

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
        kMyCollectedWebsiteProvider;

part 'article_provider.g.dart';

const List<String> collects = <String>[
  kMyCollectedArticleProvider,
  kMyCollectedWebsiteProvider,
];

@riverpod
class AppArticle extends _$AppArticle {
  late Http http;
  late String from;
  late ProviderBase<dynamic> provider;

  Map<String, ProviderBase<dynamic>> getProvidersJson() =>
      ref.container.getAllProviderElements().fold(
        <String, ProviderBase<dynamic>>{},
        (
          Map<String, ProviderBase<dynamic>> previousValue,
          ProviderElementBase<dynamic> e,
        ) {
          if (collects.contains(e.provider.name)) {
            return <String, ProviderBase<dynamic>>{
              ...previousValue,
              e.provider.name!: e.provider,
            };
          }

          return previousValue;
        },
      );

  /// [kMyCollectedArticleProvider] and [kMyCollectedWebsiteProvider] is
  /// autoDispose provider, So if they exist, it can be considered to be
  /// currently in the [MyCollectionsScreen]
  /// that is, they can be searched first from them
  WebViewModel? findCollectedWebsite(
    Map<String, ProviderBase<dynamic>> providers, {
    required int articleId,
  }) {
    if (!providers.keys.contains(kMyCollectedWebsiteProvider)) {
      return null;
    }

    from = kMyCollectedWebsiteProvider;
    provider = providers[kMyCollectedWebsiteProvider]!;

    final CollectedWebsiteModel? collectedWebsite = ref
        .read(provider as ProviderBase<ListViewState<CollectedWebsiteModel>>)
        .whenOrNull((List<CollectedWebsiteModel> list) => list)
        ?.firstWhereOrNull((CollectedWebsiteModel e) => e.id == articleId);

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

  WebViewModel? findCollectedArticle(
    Map<String, ProviderBase<dynamic>> providers, {
    required int articleId,
  }) {
    if (!providers.keys.contains(kMyCollectedArticleProvider)) {
      return null;
    }

    from = kMyCollectedArticleProvider;
    provider = providers[kMyCollectedArticleProvider]!;

    final CollectedArticleModel? collectedArticle = ref
        .read(provider
            as ProviderBase<RefreshListViewState<CollectedArticleModel>>)
        .whenOrNull((_, __, List<CollectedArticleModel> list) => list)
        ?.firstWhereOrNull((CollectedArticleModel e) => e.id == articleId);

    if (collectedArticle != null) {
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

  Future<WebViewModel?> findArticle(int id) async {
    final ArticleModel? article = await http.fetchArticleInfo(articleId: id);

    if (article != null) {
      return WebViewModel(
        id: article.id,
        link: _adjustArticleURL2Https(article.link),
        title: article.title,
        collect: article.collect,
      );
    }

    return null;
  }

  String _adjustArticleURL2Https(String link) {
    final RegExp domainReg = RegExp('http://(www.)?$kDomain');

    if (domainReg.hasMatch(link)) {
      return link.replaceFirstMapped(
        domainReg,
        (_) => 'https://$kDomain',
      );
    } else if (link.startsWith('/')) {
      return '$kBaseUrl$link';
    }

    return link;
  }

  @override
  Future<WebViewModel> build(int articleId) async {
    http = ref.watch(networkProvider);

    final Map<String, ProviderBase<dynamic>> providers = getProvidersJson();

    final WebViewModel? webViewModel =
        findCollectedWebsite(providers, articleId: articleId) ??
            findCollectedArticle(providers, articleId: articleId) ??
            await findArticle(articleId);

    if (webViewModel != null) {
      return webViewModel.copyWith(
        withCookie: webViewModel.link.startsWith(kBaseUrl),
      );
    } else {
      throw AppException(
        errorCode: 404,
        message: S.current.articleNotFound,
        detail: S.current.articleNotFoundMsg,
      );
    }
  }

  Future<void> collectCollectedArticle(
    WebViewModel webView, {
    required bool value,
  }) async {
    final AutoDisposeStateNotifierProvider<MyCollectedArticleNotifier,
            RefreshListViewState<CollectedArticleModel>> realProvider =
        provider as AutoDisposeStateNotifierProvider<MyCollectedArticleNotifier,
            RefreshListViewState<CollectedArticleModel>>;
    if (value) {
      await http.addCollectedArticleByArticleId(articleId: webView.id);
    } else {
      ref.read(realProvider.notifier).requestCancelCollect(
            collectId: webView.id,
            articleId: webView.originId,
          );
    }
    ref
        .read(realProvider.notifier)
        .switchCollect(webView.id, changedValue: value);
  }

  Future<void> collectCollectedWebsite(
    WebViewModel webView, {
    required bool value,
  }) async {
    final AutoDisposeStateNotifierProvider<MyCollectedWebsiteNotifier,
            ListViewState<CollectedWebsiteModel>> realProvider =
        provider as AutoDisposeStateNotifierProvider<MyCollectedWebsiteNotifier,
            ListViewState<CollectedWebsiteModel>>;
    if (value) {
      final CollectedWebsiteModel? newCollectedWebsite =
          await ref.read(realProvider.notifier).add(
                title: webView.title ?? '',
                link: webView.link,
                needLoading: false,
              );

      if (newCollectedWebsite != null) {
        state = AsyncValue<WebViewModel>.data(webView.copyWith(
          id: newCollectedWebsite.id,
          collect: true,
        ));
      }
    } else {
      await ref
          .read(realProvider.notifier)
          .requestCancelCollect(collectId: webView.id);
    }

    ref
        .read(realProvider.notifier)
        .switchCollect(webView.id, changedValue: value);
  }

  Future<void> collectArticle({
    required bool value,
    required int id,
  }) async {
    if (value) {
      await http.addCollectedArticleByArticleId(articleId: id);
    } else {
      await http.deleteCollectedArticleByArticleId(articleId: id);
    }
  }

  void collect(bool value) {
    state.whenOrNull(data: (WebViewModel? webView) async {
      if (webView != null) {
        state = AsyncValue<WebViewModel>.data(webView.copyWith(collect: value));
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
            await collectArticle(value: value, id: webView.id);
          }
        } catch (e, s) {
          DialogUtils.danger(
            ViewError.create(e, s).errorMessage(S.current.failed),
          );
        }
      }
    });
  }
}
