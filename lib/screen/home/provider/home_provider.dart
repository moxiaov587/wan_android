import 'dart:async';
import 'dart:ui' as ui show Image;

import 'package:collection/collection.dart';
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
  Future<List<BannerCache>> build() async {
    final CancelToken cancelToken = ref.cancelToken();

    _isar = ref.read(appDatabaseProvider);

    final List<BannerCache> homeBanners = await ref
        .watch(networkProvider)
        .fetchHomeBanners(cancelToken: cancelToken);

    final List<BannerCache> homeBannersFromCache =
        _isar.bannerCaches.where().sortByOrderDesc().findAll();

    if (!homeBanners.equals(homeBannersFromCache)) {
      final Iterable<Future<BannerCache>> futures =
          homeBanners.map((BannerCache banner) async {
        if (banner.imagePath == null) {
          return banner;
        }

        final ByteData byteData =
            await _networkAssetBundle.load(banner.imagePath!);

        final Uint8List uint8List = byteData.buffer.asUint8List();

        final ui.Image decodeImage = await decodeImageFromList(uint8List);

        final PaletteGenerator paletteGenerator =
            await PaletteGenerator.fromImage(decodeImage);

        final PaletteColor? paletteColor =
            paletteGenerator.vibrantColor ?? paletteGenerator.dominantColor;

        return banner.copyWith(
          primaryColorValue: paletteColor?.color.value,
          textColorValue: paletteColor?.bodyTextColor.value,
        );
      });

      _networkAssetBundle.clear();

      final List<BannerCache> banners = await Future.wait(futures);

      unawaited(
        _isar.writeAsyncWith<void, List<BannerCache>>(banners,
            (Isar isar, List<BannerCache> data) {
          isar.bannerCaches
            ..clear()
            ..putAll(data);
        }),
      );

      return banners;
    }

    return homeBannersFromCache;
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
    final AsyncValue<List<BannerCache>> homeBanner =
        ref.watch(homeBannerProvider);

    _colors = homeBanner.valueOrNull
        ?.map((BannerCache banner) => banner.primaryColorValue);

    return _colors?.first;
  }

  void onPageChanged(int index) {
    state = _colors?.elementAt(index);
  }
}

@riverpod
Future<List<ArticleModel>> homeTopArticles(HomeTopArticlesRef ref) {
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

    final List<ArticleModel> topArticles = await ref.watch(
      homeTopArticlesProvider.selectAsync((List<ArticleModel> data) => data),
    );

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
