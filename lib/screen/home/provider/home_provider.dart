import 'dart:ui' as ui show Image;

import 'package:diox/diox.dart';
import 'package:flutter/rendering.dart' show decodeImageFromList;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../app/http/http.dart' show kBaseUrl;
import '../../../app/http/wan_android_api.dart';
import '../../../app/provider/provider.dart';
import '../../../app/provider/view_state.dart';
import '../../../database/database_manager.dart';
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

final AutoDisposeStateNotifierProvider<BannerNotifier,
        ListViewState<HomeBannerCache>> homeBannerProvider =
    StateNotifierProvider.autoDispose<BannerNotifier,
        ListViewState<HomeBannerCache>>((_) {
  return BannerNotifier(
    const ListViewState<HomeBannerCache>.loading(),
  );
});

class BannerNotifier extends BaseListViewNotifier<HomeBannerCache> {
  BannerNotifier(super.state);

  final NetworkAssetBundle _networkAssetBundle =
      NetworkAssetBundle(Uri.parse(kBaseUrl));

  @override
  Future<List<HomeBannerCache>> loadData() async {
    final List<BannerModel> homeBanners =
        await WanAndroidAPI.fetchHomeBanners();

    final List<HomeBannerCache> homeBannersFromCache = DatabaseManager
        .homeBannerCaches
        .where()
        .sortByOrderDesc()
        .findAllSync();

    if (_compareRequestAndCache(homeBanners, homeBannersFromCache)) {
      final Iterable<Future<HomeBannerCache>> futures =
          homeBanners.map((BannerModel banner) async {
        final ByteData byteData =
            await _networkAssetBundle.load(banner.imagePath);

        final Uint8List uint8List = byteData.buffer.asUint8List();

        final ui.Image decodeImage = await decodeImageFromList(uint8List);

        final PaletteGenerator paletteGenerator =
            await PaletteGenerator.fromImage(decodeImage);

        final PaletteColor? paletteColor =
            paletteGenerator.vibrantColor ?? paletteGenerator.dominantColor;

        return HomeBannerCache()
          ..id = banner.id
          ..isVisible = banner.isVisible
          ..order = banner.order
          ..type = banner.type
          ..title = banner.title
          ..desc = banner.desc
          ..url = banner.url
          ..imageUrl = banner.imagePath
          ..primaryColorValue = paletteColor?.color.value
          ..textColorValue = paletteColor?.bodyTextColor.value;
      });

      final List<HomeBannerCache> banners = await Future.wait(futures);

      DatabaseManager.isar.writeTxn<void>(() async {
        await DatabaseManager.homeBannerCaches.clear();
        DatabaseManager.homeBannerCaches.putAll(banners);
      });

      return banners;
    }

    return homeBannersFromCache;
  }

  bool _compareRequestAndCache(
    List<BannerModel> data,
    List<HomeBannerCache> cache,
  ) {
    if (data.length != cache.length) {
      return true;
    }

    for (int i = 0; i < data.length; i++) {
      if (data[i].id != cache[i].id) {
        return true;
      }
    }

    return false;
  }
}

extension Int2ColorExtension on int? {
  Color? get toColor => this == null ? null : Color(this!);
}

final AutoDisposeStateNotifierProvider<CurrentBannerColorNotifier, Color?>
    currentBannerColorProvider =
    StateNotifierProvider.autoDispose<CurrentBannerColorNotifier, Color?>(
  (AutoDisposeStateNotifierProviderRef<CurrentBannerColorNotifier, Color?>
      ref) {
    return ref.watch(homeBannerProvider).whenOrNull(
              (List<HomeBannerCache> list) => CurrentBannerColorNotifier(
                list.first.primaryColorValue.toColor,
                colors: list.map((HomeBannerCache banner) =>
                    banner.primaryColorValue.toColor),
              ),
            ) ??
        CurrentBannerColorNotifier(null);
  },
);

class CurrentBannerColorNotifier extends StateNotifier<Color?> {
  CurrentBannerColorNotifier(
    super.state, {
    this.colors,
  });

  final Iterable<Color?>? colors;

  void onPageChanged(int index) {
    state = colors?.elementAt(index);
  }
}

final AutoDisposeStateNotifierProvider<TopArticleNotifier,
        ListViewState<ArticleModel>> homeTopArticleProvider =
    StateNotifierProvider.autoDispose<TopArticleNotifier,
        ListViewState<ArticleModel>>((_) {
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

final AutoDisposeStateNotifierProvider<ArticleNotifier,
        RefreshListViewState<ArticleModel>> homeArticleProvider =
    StateNotifierProvider.autoDispose<ArticleNotifier,
        RefreshListViewState<ArticleModel>>(
  (AutoDisposeStateNotifierProviderRef<ArticleNotifier,
          RefreshListViewState<ArticleModel>>
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
