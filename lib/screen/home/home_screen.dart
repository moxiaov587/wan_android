import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;

import '../../../widget/view_state_widget.dart';
import '../../app/http/interceptors/interceptors.dart';
import '../../app/l10n/generated/l10n.dart';
import '../../app/provider/mixin/refresh_list_view_state_mixin.dart';
import '../../app/theme/app_theme.dart';
import '../../contacts/icon_font_icons.dart';
import '../../database/app_database.dart';
import '../../extensions/extensions.dart';
import '../../model/models.dart';
import '../../router/data/app_routes.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/html_parse_utils.dart';
import '../../utils/screen_utils.dart';
import '../../widget/article.dart';
import '../../widget/capsule_ink.dart';
import '../../widget/custom_search_delegate.dart';
import '../../widget/gap.dart';
import '../../widget/indent_divider.dart';
import '../../widget/level_tag.dart';
import '../authorized/provider/authorized_provider.dart';
import '../drawer/home_drawer.dart';
import 'provider/home_provider.dart';

part 'home_search_delegate.dart';
part 'project.dart';
part 'project_type_bottom_sheet.dart';
part 'qa.dart';
part 'square.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.initialPath, super.key});

  final HomePath initialPath;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = const <Widget>[
    _Home(),
    _Square(),
    _QA(),
    _Project(),
  ];

  late final ValueNotifier<int> _currentIndexNotifier =
      ValueNotifier<int>(widget.initialPath.index);

  late final PageController _pageController = PageController(
    initialPage: _currentIndexNotifier.value,
  );

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const HomeDrawer(),
        drawerScrimColor: context.theme.colorScheme.scrim,
        body: PageView.builder(
          controller: _pageController,
          itemCount: _pages.length,
          itemBuilder: (_, int index) => Material(
            color: context.theme.scaffoldBackgroundColor,
            child: _pages[index],
          ),
          onPageChanged: (int index) {
            _currentIndexNotifier.value = index;
          },
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _currentIndexNotifier,
          builder: (BuildContext context, int index, _) => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: index,
            onTap: _pageController.jumpToPage,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: S.of(context).home,
                icon: const Icon(IconFontIcons.homeLine),
                activeIcon: const Icon(IconFontIcons.homeFill),
                tooltip: S.of(context).home,
              ),
              BottomNavigationBarItem(
                label: S.of(context).square,
                icon: const Icon(IconFontIcons.seedlingLine),
                activeIcon: const Icon(IconFontIcons.seedlingFill),
                tooltip: S.of(context).square,
              ),
              BottomNavigationBarItem(
                label: S.of(context).question,
                icon: const Icon(IconFontIcons.questionnaireLine),
                activeIcon: const Icon(IconFontIcons.questionnaireFill),
                tooltip: S.of(context).question,
              ),
              BottomNavigationBarItem(
                label: S.of(context).project,
                icon: const Icon(IconFontIcons.androidLine),
                activeIcon: const Icon(IconFontIcons.androidFill),
                tooltip: S.of(context).project,
              ),
            ],
          ),
        ),
      );
}

enum HomePath {
  home,
  square,
  qa,
  project,
}

class _Home extends ConsumerStatefulWidget {
  const _Home();

  @override
  ConsumerState<_Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<_Home>
    with
        AutomaticKeepAliveClientMixin,
        RefreshListViewStateMixin<HomeArticleProvider, ArticleModel, _Home> {
  @override
  bool get wantKeepAlive => true;

  @override
  HomeArticleProvider get provider => homeArticleProvider();

  @override
  PaginationDataRefreshable<ArticleModel> get refreshable => provider.future;

  @override
  FutureOr<void> onRetry() async {
    if (ref.read(homeTopArticlesProvider).hasError) {
      ref.invalidate(homeTopArticlesProvider);
    } else {
      await super.onRetry();
    }
  }

  @override
  Future<LoadingMoreStatus?> loadMore() =>
      ref.read(provider.notifier).loadMore();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: CustomScrollView(
        slivers: <Widget>[
          const _HomeAppBar(),
          pullDownIndicator,
          Consumer(
            builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                  data: (PaginationData<ArticleModel> data) {
                    final List<ArticleModel> list = data.datas;

                    if (list.isEmpty) {
                      return const SliverFillRemaining(child: EmptyWidget());
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, int index) {
                          final ArticleModel article = list[index];

                          return ArticleTile(
                            key: Key('home_article_${article.id}'),
                            article: article,
                          );
                        },
                        childCount: list.length,
                      ),
                    );
                  },
                  loading: loadingIndicatorBuilder,
                  error: errorIndicatorBuilder,
                ),
          ),
          loadMoreIndicator,
        ],
      ),
    );
  }
}

class _HomeAppBar extends StatefulWidget {
  const _HomeAppBar();

  @override
  State<_HomeAppBar> createState() => __HomeAppBarState();
}

class __HomeAppBarState extends State<_HomeAppBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
        pinned: true,
        delegate: _HomeAppBarDelegate(
          this,
          minHeight: kToolbarHeight,
          maxHeight: kToolbarHeight + 200.0,
        ),
      );
}

class _HomeAppBarDelegate extends SliverPersistentHeaderDelegate {
  const _HomeAppBarDelegate(
    this.vsync, {
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  final TickerProvider vsync;

  final double minHeight;

  final double maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double visibleHeight = maxExtent - minExtent;

    final double progress = (shrinkOffset / visibleHeight).clamp(0.0, 1.0);

    final double reversedProgress = (1 - progress).clamp(0.0, 1.0);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Opacity(
          opacity: progress,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: context.isDarkTheme
                    ? <Color>[
                        AppColors.arcoBlueDark.shade5,
                        AppColors.arcoBlueDark.shade3,
                      ]
                    : <Color>[
                        AppColors.arcoBlue.shade3,
                        AppColors.arcoBlue.shade5,
                      ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: ScreenUtils.topSafeHeight),
              child: Consumer(
                builder: (_, WidgetRef ref, __) {
                  final UserInfoModel? userInfo = ref.watch(
                    authorizedProvider.select(
                      (AsyncValue<UserInfoModel?> data) => data.valueOrNull,
                    ),
                  );

                  if (userInfo == null) {
                    return Center(
                      child: Text(
                        S.of(context).appName,
                        style: context.theme.textTheme.titleLarge,
                      ),
                    );
                  }

                  return _HomeAppBarUserInfo(userInfo: userInfo);
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: -shrinkOffset,
          left: 0.0,
          right: 0.0,
          height: maxExtent,
          child: Opacity(
            opacity: reversedProgress,
            child: Consumer(
              builder: (_, WidgetRef ref, Widget? child) {
                final Color color = ref
                        .watch(currentHomeBannerBackgroundColorValueProvider)
                        .toColor ??
                    context.theme.primaryColor;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: AppTheme.contentPaddingOnlyHorizontal.copyWith(
                    top: ScreenUtils.topSafeHeight,
                    bottom: kStyleUint4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[color, color.withOpacity(0.0)],
                      stops: const <double>[0.0, 0.8],
                    ),
                  ),
                  child: child,
                );
              },
              child: const _BannerCarousel(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight + ScreenUtils.topSafeHeight;

  @override
  bool shouldRebuild(covariant _HomeAppBarDelegate oldDelegate) =>
      vsync != oldDelegate.vsync ||
      minHeight != oldDelegate.minHeight ||
      maxHeight != oldDelegate.maxHeight;
}

class _HomeAppBarUserInfo extends StatelessWidget {
  const _HomeAppBarUserInfo({required this.userInfo});

  final UserInfoModel userInfo;

  String? get name =>
      userInfo.user.nickname.strictValue ??
      userInfo.user.publicName.strictValue;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: kStyleUint4),
        child: Row(
          children: <Widget>[
            Material(
              shape: const StadiumBorder(),
              child: Ink(
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                      width: kStyleUint * 10,
                      height: kStyleUint * 10,
                    ),
                    child: Center(
                      child: Text(
                        name?.substring(0, 1).toUpperCase() ?? '-',
                        style: context.theme.textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Gap.hn(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name ?? '',
                  style: context.theme.textTheme.titleSmall,
                ),
                LevelTag(
                  level: userInfo.userPoints.level,
                  scaleFactor: 0.9,
                  isOutlined: true,
                ),
              ],
            ),
          ],
        ),
      );
}

class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel();

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: const BorderRadius.only(
                topLeft: AppTheme.radius,
                topRight: AppTheme.radius,
              ),
              child: ColoredBox(
                color: context.theme.cardColor,
                child: Consumer(
                  builder: (_, WidgetRef ref, __) => ref
                      .watch(homeBannerProvider)
                      .when(
                        skipLoadingOnRefresh: false,
                        data: (List<HomeBannerCache> list) => PageView.builder(
                          onPageChanged: ref
                              .read(
                                currentHomeBannerBackgroundColorValueProvider
                                    .notifier,
                              )
                              .onPageChanged,
                          itemBuilder: (BuildContext context, int index) =>
                              _BannerCarouselItem(
                            key: Key(
                              'home_banner_${list[index].id}',
                            ),
                            homeBanner: list[index],
                          ),
                          itemCount: list.length,
                        ),
                        loading: () => const LoadingWidget.listView(),
                        error: (Object e, StackTrace s) {
                          final AppException error = AppException.create(e, s);

                          return Material(
                            child: Ink(
                              width: ScreenUtils.width,
                              child: InkWell(
                                onTap: () {
                                  ref.invalidate(homeBannerProvider);
                                },
                                child: Padding(
                                  padding: AppTheme.bodyPaddingOnlyHorizontal,
                                  child: Column(
                                    children: <Widget>[
                                      const Gap.v(value: kStyleUint4 * 2),
                                      Icon(
                                        IconFontIcons.refreshLine,
                                        color: context
                                            .theme.textTheme.bodySmall!.color,
                                        size: 36.0,
                                      ),
                                      const Gap.vn(),
                                      Text(
                                        // ignore: lines_longer_than_80_chars
                                        '${error.message ?? error.detail ?? S.of(context).unknownError}(${error.statusCode ?? -1})',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Gap.vs(),
                                      Text(S.of(context).tapToRetry),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ),
              ),
            ),
          ),
          Material(
            color: context.theme.cardColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: AppTheme.radius,
                bottomRight: AppTheme.radius,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kStyleUint2),
              child: CapsuleInk(
                color: context.theme.bottomNavigationBarTheme.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: kStyleUint),
                      child: Icon(
                        IconFontIcons.searchEyeLine,
                        color: context.theme.textTheme.bodyMedium!.color,
                        size: AppTextTheme.body1,
                      ),
                    ),
                    Text(S.of(context).searchForSomething),
                  ],
                ),
                onTap: () {
                  unawaited(const SearchRoute().push(context));
                },
              ),
            ),
          ),
        ],
      );
}

class _BannerCarouselItem extends StatelessWidget {
  const _BannerCarouselItem({required this.homeBanner, super.key});

  final HomeBannerCache homeBanner;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            homeBanner.imageUrl,
            fit: BoxFit.fill,
            loadingBuilder: (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }

              final double? progress =
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null;
              return Center(
                child: progress != null
                    ? CupertinoActivityIndicator.partiallyRevealed(
                        progress: progress,
                      )
                    : const CupertinoActivityIndicator(),
              );
            },
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) =>
                Center(
              child: Icon(
                Icons.broken_image_rounded,
                color: context.theme.dividerColor,
                size: kStyleUint4 * 2,
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: EdgeInsets.only(
                right: AppTheme.contentPadding.right,
              ),
              alignment: Alignment.centerRight,
              width: ScreenUtils.width,
              height: 50.0,
              color: (homeBanner.primaryColorValue.toColor ??
                      context.theme.colorScheme.background)
                  .withOpacity(0.2),
              child: Text(
                homeBanner.title,
                style: context.theme.textTheme.titleMedium!.copyWith(
                  color: homeBanner.textColorValue.toColor,
                ),
              ),
            ),
          ),
        ],
      );
}
