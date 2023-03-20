import 'dart:ui' as ui show Image;

import 'package:flutter/rendering.dart' show decodeImageFromList;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/http/http.dart';

import '../../../app/provider/mixin/notifier_update_mixin.dart';
import '../../../app/provider/provider.dart';
import '../../../app/provider/view_state.dart';
import '../../../database/app_database.dart';
import '../../../model/models.dart';

part 'project_provider.dart';
part 'question_provider.dart';
part 'search_provider.dart';
part 'square_provider.dart';
part 'home_provider.g.dart';

const String kHomeArticleProvider = 'kHomeArticleProvider';
const String kSquareArticleProvider = 'kSquareArticleProvider';
const String kSearchArticleProvider = 'kSearchArticleProvider';
const String kQuestionArticleProvider = 'kQuestionArticleProvider';
const String kProjectArticleProvider = 'kProjectArticleProvider';

@Riverpod(dependencies: <Object>[appDatabase])
class HomeBanner extends _$HomeBanner {
  late Isar isar;

  final NetworkAssetBundle _networkAssetBundle =
      NetworkAssetBundle(Uri.parse(kBaseUrl));

  @override
  Future<List<HomeBannerCache>> build() async {
    final CancelToken cancelToken = ref.cancelToken();

    isar = ref.read(appDatabaseProvider);

    final List<BannerModel> homeBanners = await ref
        .watch(networkProvider)
        .fetchHomeBanners(cancelToken: cancelToken);

    final List<HomeBannerCache> homeBannersFromCache =
        isar.homeBannerCaches.where().sortByOrderDesc().findAllSync();

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

      isar.writeTxn<void>(() async {
        await isar.homeBannerCaches.clear();
        isar.homeBannerCaches.putAll(banners);
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

@Riverpod(dependencies: <Object>[HomeBanner])
class CurrentHomeBannerBackgroundColorValue
    extends _$CurrentHomeBannerBackgroundColorValue {
  late Iterable<int?>? colors;

  @override
  int? build() {
    final AsyncValue<List<HomeBannerCache>> homeBanner =
        ref.watch(homeBannerProvider);

    colors = homeBanner.valueOrNull
        ?.map((HomeBannerCache banner) => banner.primaryColorValue);

    return colors?.first;
  }

  void onPageChanged(int index) {
    state = colors?.elementAt(index);
  }
}

@riverpod
Future<List<ArticleModel>> homeTopArticles(HomeTopArticlesRef ref) {
  final CancelToken cancelToken = ref.cancelToken();

  return ref
      .watch(networkProvider)
      .fetchHomeTopArticles(cancelToken: cancelToken);
}

typedef HomeArticleProvider = AutoDisposeStateNotifierProvider<ArticleNotifier,
    RefreshListViewState<ArticleModel>>;

final HomeArticleProvider homeArticleProvider = StateNotifierProvider
    .autoDispose<ArticleNotifier, RefreshListViewState<ArticleModel>>(
  (AutoDisposeStateNotifierProviderRef<ArticleNotifier,
          RefreshListViewState<ArticleModel>>
      ref) {
    final CancelToken cancelToken = ref.cancelToken();

    final Http http = ref.read(networkProvider);

    return ref.watch(homeTopArticlesProvider).when(
          skipLoadingOnRefresh: false,
          data: (List<ArticleModel> list) => ArticleNotifier(
            const RefreshListViewState<ArticleModel>.loading(),
            topArticles: list,
            http: http,
            cancelToken: cancelToken,
          )..initData(),
          loading: () => ArticleNotifier(
            const RefreshListViewState<ArticleModel>.loading(),
            http: http,
            cancelToken: cancelToken,
          ),
          error: (Object e, StackTrace s) => ArticleNotifier(
            RefreshListViewState<ArticleModel>.error(e, s),
            http: http,
            cancelToken: cancelToken,
          ),
        );
  },
  name: kHomeArticleProvider,
);

class ArticleNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  ArticleNotifier(
    super.state, {
    this.topArticles,
    required this.http,
    this.cancelToken,
  }) : super(initialPageNum: 0);

  final List<ArticleModel>? topArticles;

  final Http http;

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    RefreshListViewStateData<ArticleModel> data = (await http.fetchHomeArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();

    if (pageNum == initialPageNum && topArticles != null) {
      data = data.copyWith(
        list: topArticles!
            .map((ArticleModel article) => article.copyWith(isTop: true))
            .toList()
          ..addAll(data.list),
      );
    }

    return data;
  }
}
