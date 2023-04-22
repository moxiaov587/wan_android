import 'dart:async';
import 'dart:ui' as ui show Image;

import 'package:flutter/rendering.dart' show decodeImageFromList;
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/http/http.dart';

import '../../../app/provider/mixin/refresh_list_view_state_mixin.dart';
import '../../../database/app_database.dart';
import '../../../model/models.dart';

part 'project_provider.dart';
part 'question_provider.dart';
part 'search_provider.dart';
part 'square_provider.dart';
part 'home_provider.g.dart';

@Riverpod(dependencies: <Object>[appDatabase])
class HomeBanner extends _$HomeBanner {
  late Isar _isar;

  final NetworkAssetBundle _networkAssetBundle =
      NetworkAssetBundle(Uri.parse(kBaseUrl));

  @override
  Future<List<HomeBannerCache>> build() async {
    final CancelToken cancelToken = ref.cancelToken();

    _isar = ref.read(appDatabaseProvider);

    final List<BannerModel> homeBanners = await ref
        .watch(networkProvider)
        .fetchHomeBanners(cancelToken: cancelToken);

    final List<HomeBannerCache> homeBannersFromCache =
        _isar.homeBannerCaches.where().sortByOrderDesc().findAllSync();

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

      _networkAssetBundle.clear();

      final List<HomeBannerCache> banners = await Future.wait(futures);

      unawaited(
        _isar.writeTxn(() async {
          await _isar.homeBannerCaches.clear();
          await _isar.homeBannerCaches.putAll(banners);
        }),
      );

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

@Riverpod(dependencies: <Object>[HomeBanner])
class CurrentHomeBannerBackgroundColorValue
    extends _$CurrentHomeBannerBackgroundColorValue {
  late Iterable<int?>? _colors;

  @override
  int? build() {
    final AsyncValue<List<HomeBannerCache>> homeBanner =
        ref.watch(homeBannerProvider);

    _colors = homeBanner.valueOrNull
        ?.map((HomeBannerCache banner) => banner.primaryColorValue);

    return _colors?.first;
  }

  void onPageChanged(int index) {
    state = _colors?.elementAt(index);
  }
}

@Riverpod(keepAlive: true)
Future<List<ArticleModel>> homeTopArticles(HomeTopArticlesRef ref) async {
  final CancelToken cancelToken = ref.cancelToken();

  return ref
      .watch(networkProvider)
      .fetchHomeTopArticles(cancelToken: cancelToken);
}

@riverpod
class HomeArticle extends _$HomeArticle with LoadMoreMixin<ArticleModel> {
  late Http _http;

  @override
  Future<PaginationData<ArticleModel>> build({
    int pageNum = 0,
    int pageSize = kDefaultPageSize,
  }) async {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    final List<ArticleModel> topArticles =
        ref.read(homeTopArticlesProvider).valueOrNull ??
            await ref.watch(homeTopArticlesProvider.future);

    final PaginationData<ArticleModel> data = await _http.fetchHomeArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    );

    if (pageNum == 0) {
      return data.copyWith(
        curPage: 0, // Fix curPage.
        datas: topArticles
            .map(
              (ArticleModel e) => e.copyWith(isTop: true),
            )
            .toList()
          ..addAll(data.datas),
      );
    }

    return data;
  }

  @override
  Future<PaginationData<ArticleModel>> buildMore(int pageNum, int pageSize) =>
      build(pageNum: pageNum, pageSize: pageSize);
}
