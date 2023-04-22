import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/http/http.dart';
import '../../../app/http/interceptors/interceptors.dart';
import '../../../app/l10n/generated/l10n.dart';
import '../../../model/models.dart';
import '../../../utils/dialog_utils.dart';
import '../../drawer/home_drawer.dart' show MyCollectionsScreen;
import '../../drawer/provider/drawer_provider.dart'
    show myCollectedArticleProvider, myCollectedWebsiteProvider;

part 'article_provider.g.dart';

@riverpod
class AppArticle extends _$AppArticle {
  late Http _http;

  /// [myCollectedArticleProvider] and [myCollectedWebsiteProvider] is
  /// autoDispose provider, So if they exist, it can be considered to be
  /// currently in the [MyCollectionsScreen] that is, they can be searched
  /// first from them.
  WebViewModel? findCollectedWebsite(int websiteId) {
    if (!ref.container.exists(myCollectedWebsiteProvider)) {
      return null;
    }

    final CollectedWebsiteModel? collectedWebsite = ref
        .read(myCollectedWebsiteProvider)
        .whenOrNull(data: (List<CollectedWebsiteModel> list) => list)
        ?.firstWhereOrNull((CollectedWebsiteModel e) => e.id == websiteId);

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

  WebViewModel? findCollectedArticle(int articleId) {
    if (!ref.container.exists(myCollectedArticleProvider())) {
      return null;
    }

    final CollectedArticleModel? collectedArticle = ref
        .read(myCollectedArticleProvider())
        .whenOrNull(
          data: (PaginationData<CollectedArticleModel> data) => data.datas,
        )
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
    final ArticleModel? article = await _http.fetchArticleInfo(articleId: id);

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
    _http = ref.watch(networkProvider);

    final WebViewModel? webViewModel = findCollectedWebsite(articleId) ??
        findCollectedArticle(articleId) ??
        await findArticle(articleId);

    if (webViewModel != null) {
      return webViewModel.copyWith(
        withCookie: webViewModel.link.startsWith(kBaseUrl),
      );
    } else {
      throw AppException(
        statusCode: 404,
        message: S.current.articleNotFound,
        detail: S.current.articleNotFoundMsg,
      );
    }
  }

  Future<void> collectCollectedArticle(
    WebViewModel webView, {
    required bool value,
  }) async {
    if (value) {
      await _http.addCollectedArticleByArticleId(articleId: webView.id);
    } else {
      await ref
          .read(myCollectedArticleProvider().notifier)
          .requestCancelCollect(
            collectId: webView.id,
            articleId: webView.originId,
          );
    }

    final int? index = ref.read(myCollectedArticleProvider()).whenOrNull(
          data: (PaginationData<CollectedArticleModel> data) =>
              data.datas.indexWhere(
            (CollectedArticleModel e) => e.id == webView.id,
          ),
        );

    ref
        .read(myCollectedArticleProvider().notifier)
        .switchCollect(index ?? -1, changedValue: value);
  }

  Future<void> collectCollectedWebsite(
    WebViewModel webView, {
    required bool value,
  }) async {
    if (value) {
      final CollectedWebsiteModel? newCollectedWebsite =
          await ref.read(myCollectedWebsiteProvider.notifier).add(
                title: webView.title ?? '',
                link: webView.link,
                needLoading: false,
              );

      if (newCollectedWebsite != null) {
        state = AsyncValue<WebViewModel>.data(
          webView.copyWith(
            id: newCollectedWebsite.id,
            collect: true,
          ),
        );
      }
    } else {
      await ref
          .read(myCollectedWebsiteProvider.notifier)
          .requestCancelCollect(collectId: webView.id);
    }

    final int? index = ref.read(myCollectedWebsiteProvider).whenOrNull(
          data: (List<CollectedWebsiteModel> list) => list.indexWhere(
            (CollectedWebsiteModel e) => e.id == webView.id,
          ),
        );

    ref
        .read(myCollectedWebsiteProvider.notifier)
        .switchCollect(index ?? -1, changedValue: value);
  }

  Future<void> collectArticle({
    required bool value,
    required int id,
  }) async {
    if (value) {
      await _http.addCollectedArticleByArticleId(articleId: id);
    } else {
      await _http.deleteCollectedArticleByArticleId(articleId: id);
    }
  }

  Future<void>? collect({required bool value}) => state.whenOrNull(
        data: (WebViewModel? webView) async {
          if (webView != null) {
            state =
                AsyncValue<WebViewModel>.data(webView.copyWith(collect: value));
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
            } on Exception catch (e, s) {
              DialogUtils.danger(
                AppException.create(e, s).errorMessage(S.current.failed),
              );
            }
          }
        },
      );
}
