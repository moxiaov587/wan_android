import 'dart:ui' as ui show Image;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' show decodeImageFromList;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../app/http/http.dart' show kBaseUrl;
import '../../../app/http/wan_android_api.dart';
import '../../../app/provider/provider.dart';
import '../../../app/provider/view_state.dart';
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

@immutable
class HomeBannerModel {
  const HomeBannerModel({
    required this.id,
    required this.title,
    required this.bytes,
    this.primaryColor,
    this.textColor,
  });

  final int id;
  final String title;
  final Uint8List bytes;
  final Color? primaryColor;
  final Color? textColor;

  @override
  bool operator ==(Object other) =>
      other is HomeBannerModel &&
      id == other.id &&
      bytes == other.bytes &&
      title == other.title &&
      primaryColor == other.primaryColor &&
      textColor == other.textColor;

  @override
  int get hashCode => Object.hash(id, bytes, title, primaryColor, textColor);
}

final StateNotifierProvider<BannerNotifier, ListViewState<HomeBannerModel>>
    homeBannerProvider =
    StateNotifierProvider<BannerNotifier, ListViewState<HomeBannerModel>>((_) {
  return BannerNotifier(
    const ListViewState<HomeBannerModel>.loading(),
  );
});

class BannerNotifier extends BaseListViewNotifier<HomeBannerModel> {
  BannerNotifier(super.state);

  final NetworkAssetBundle _networkAssetBundle =
      NetworkAssetBundle(Uri.parse(kBaseUrl));

  @override
  Future<List<HomeBannerModel>> loadData() async {
    final List<BannerModel> homeBanners =
        await WanAndroidAPI.fetchHomeBanners();

    final Iterable<Future<HomeBannerModel>> futures =
        homeBanners.map((BannerModel banner) async {
      final ByteData byteData =
          await _networkAssetBundle.load(banner.imagePath);

      final Uint8List uint8List = byteData.buffer.asUint8List();

      final ui.Image decodeImage = await decodeImageFromList(uint8List);

      final ByteData? decodeByteData = await decodeImage.toByteData();

      if (decodeByteData == null) {
        return HomeBannerModel(
          id: banner.id,
          title: banner.title,
          bytes: uint8List,
        );
      }

      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromByteData(EncodedImage(
        decodeByteData,
        width: decodeImage.width,
        height: decodeImage.height,
      ));

      final PaletteColor? paletteColor =
          paletteGenerator.vibrantColor ?? paletteGenerator.dominantColor;

      return HomeBannerModel(
        id: banner.id,
        title: banner.title,
        bytes: uint8List,
        primaryColor: paletteColor?.color,
        textColor: paletteColor?.bodyTextColor,
      );
    });

    return Future.wait(futures);
  }
}

final StateNotifierProvider<CurrentBannerColorNotifier, Color?>
    currentBannerColorProvider =
    StateNotifierProvider<CurrentBannerColorNotifier, Color?>(
  (StateNotifierProviderRef<CurrentBannerColorNotifier, Color?> ref) {
    return ref.watch(homeBannerProvider).whenOrNull(
              (List<HomeBannerModel> list) => CurrentBannerColorNotifier(
                list.first.primaryColor,
                colors:
                    list.map((HomeBannerModel banner) => banner.primaryColor),
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

final StateNotifierProvider<TopArticleNotifier, ListViewState<ArticleModel>>
    homeTopArticleProvider =
    StateNotifierProvider<TopArticleNotifier, ListViewState<ArticleModel>>((_) {
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

final StateNotifierProvider<ArticleNotifier, RefreshListViewState<ArticleModel>>
    homeArticleProvider =
    StateNotifierProvider<ArticleNotifier, RefreshListViewState<ArticleModel>>(
  (StateNotifierProviderRef<ArticleNotifier, RefreshListViewState<ArticleModel>>
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
