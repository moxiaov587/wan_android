import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;

import '../../../app/provider/view_state.dart';
import '../../../widget/view_state_widget.dart';
import '../../app/l10n/generated/l10n.dart';
import '../../app/provider/mixin/list_view_state_mixin.dart';
import '../../app/provider/mixin/refresh_list_view_state_mixin.dart';
import '../../app/theme/app_theme.dart';
import '../../contacts/icon_font_icons.dart';
import '../../contacts/instances.dart';
import '../../database/database_manager.dart';
import '../../extensions/extensions.dart';
import '../../model/models.dart';
import '../../navigator/app_router_delegate.dart';
import '../../navigator/route_name.dart';
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

const String kSearchOriginParams = 'origin';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.initialPath,
  });

  final String initialPath;

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
      ValueNotifier<int>(initialPathToIndex(widget.initialPath));

  late final PageController _pageController = PageController(
    initialPage: _currentIndexNotifier.value,
  );

  int initialPathToIndex(String path) {
    final int index = RouterName.homeTabsPath.indexOf(path);

    if (index != -1) {
      return index;
    } else if (RouterName.projectType.location == path) {
      return 3;
    }

    return 0;
  }

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(Duration.zero, () {
      if (RouterName.homeDrawerPath.contains(
        context.currentBeamLocation.state.routeInformation.location,
      )) {
        Instances.scaffoldStateKey.currentState?.openDrawer();
      }
    });
  }

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Instances.scaffoldStateKey,
      drawer: const HomeDrawer(),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        itemBuilder: (_, int index) => Material(
          color: context.theme.scaffoldBackgroundColor,
          child: SafeArea(
            top: false,
            child: _pages[index],
          ),
        ),
        onPageChanged: (int value) {
          _currentIndexNotifier.value = value;
          AppRouterDelegate.instance.currentBeamState.updateWith(
            initialPath: RouterName.homeTabsPath[value],
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _currentIndexNotifier,
        builder: (BuildContext context, int index, _) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: index,
          onTap: (int value) {
            /// The [jumpToPage] will trigger [onPageChanged]
            _pageController.jumpToPage(value);
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: S.of(context).home,
              icon: const Icon(IconFontIcons.homeLine),
              activeIcon: const Icon(IconFontIcons.homeFill),
            ),
            BottomNavigationBarItem(
              label: S.of(context).square,
              icon: const Icon(IconFontIcons.seedlingLine),
              activeIcon: const Icon(IconFontIcons.seedlingFill),
            ),
            BottomNavigationBarItem(
              label: S.of(context).question,
              icon: const Icon(IconFontIcons.questionnaireLine),
              activeIcon: const Icon(IconFontIcons.questionnaireFill),
            ),
            BottomNavigationBarItem(
              label: S.of(context).project,
              icon: const Icon(IconFontIcons.androidLine),
              activeIcon: const Icon(IconFontIcons.androidFill),
            ),
          ],
        ),
      ),
    );
  }
}

class _Home extends ConsumerStatefulWidget {
  const _Home();

  @override
  ConsumerState<_Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<_Home>
    with
        AutomaticKeepAliveClientMixin,
        RefreshListViewStateMixin<
            StateNotifierProvider<ArticleNotifier,
                RefreshListViewState<ArticleModel>>,
            ArticleModel,
            _Home> {
  @override
  final bool autoInitData = false;

  @override
  void onRetry() {
    if (ref.read(homeTopArticleProvider) is ListViewStateError<ArticleModel>) {
      ref.read(homeTopArticleProvider.notifier).initData();
    } else {
      super.onRetry();
    }
  }

  @override
  void initState() {
    super.initState();

    ref.read(homeBannerProvider.notifier).initData();
    ref.read(homeTopArticleProvider.notifier).initData();
  }

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
              (int nextPageNum, bool isLastPage, List<ArticleModel> list) {
                if (list.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyWidget(),
                  );
                }

                return LoadMoreSliverList.separator(
                  loadMoreIndicatorBuilder: loadMoreIndicatorBuilder,
                  itemBuilder: (_, int index) {
                    final ArticleModel article = list[index];

                    return ArticleTile(
                      key: Key('home_article_${article.id}'),
                      article: article,
                    );
                  },
                  separatorBuilder: (_, __) => const IndentDivider(),
                  itemCount: list.length,
                );
              },
              loading: loadingIndicatorBuilder,
              error: errorIndicatorBuilder,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  StateNotifierProvider<ArticleNotifier, RefreshListViewState<ArticleModel>>
      get provider => homeArticleProvider;
}

class _HomeAppBar extends StatefulWidget {
  const _HomeAppBar();

  @override
  State<_HomeAppBar> createState() => __HomeAppBarState();
}

class __HomeAppBarState extends State<_HomeAppBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _HomeAppBarDelegate(
        this,
        minHeight: kToolbarHeight,
        maxHeight: kToolbarHeight + 200.0,
      ),
    );
  }
}

class _HomeAppBarDelegate extends SliverPersistentHeaderDelegate {
  const _HomeAppBarDelegate(
    this.vsync, {
    required this.minHeight,
    required this.maxHeight,
  });

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
                builder: (_, WidgetRef ref, Widget? title) {
                  final UserInfoModel? userInfo =
                      ref.watch<UserInfoModel?>(authorizedProvider);

                  if (userInfo == null) {
                    return title!;
                  }

                  return _HomeAppBarUserInfo(userInfo: userInfo);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      S.of(context).appName,
                      style: context.theme.textTheme.titleLarge,
                    ),
                  ],
                ),
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
                final Color color = ref.watch(currentBannerColorProvider) ??
                    context.theme.primaryColor;

                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        color,
                        color.withOpacity(0.0),
                      ],
                      stops: const <double>[
                        0.0,
                        0.8,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: AppTheme.contentPaddingOnlyHorizontal.copyWith(
                      top: ScreenUtils.topSafeHeight,
                      bottom: (ScreenUtils.topSafeHeight ~/ 2).toDouble(),
                    ),
                    child: child,
                  ),
                );
              },
              child: Column(
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
                          builder: (_, WidgetRef ref, __) {
                            return ref.watch(homeBannerProvider).when(
                                  (List<HomeBannerModel> list) =>
                                      PageView.builder(
                                    onPageChanged: ref
                                        .read(
                                          currentBannerColorProvider.notifier,
                                        )
                                        .onPageChanged,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _BannerCarouselItem(
                                        key: Key(
                                          'home_banner_${list[index].id}',
                                        ),
                                        homeBanner: list[index],
                                      );
                                    },
                                    itemCount: list.length,
                                  ),
                                  loading: () => const LoadingWidget(),
                                  error: (
                                    int? statusCode,
                                    String? message,
                                    String? detail,
                                  ) =>
                                      Ink(
                                    child: InkWell(
                                      onTap: () {
                                        ref
                                            .read(
                                              homeBannerProvider.notifier,
                                            )
                                            .initData();
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            IconFontIcons.refreshLine,
                                            color: context.theme.textTheme
                                                .bodySmall!.color,
                                            size: 36.0,
                                          ),
                                          Gap(
                                            size: GapSize.big,
                                          ),
                                          Text(
                                            '${message ?? detail ?? S.of(context).unknownError}(${statusCode ?? -1})',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Gap(),
                                          Text(S.of(context).tapToRetry),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                          },
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
                        color: context
                            .theme.bottomNavigationBarTheme.backgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: kStyleUint),
                              child: Icon(
                                IconFontIcons.searchEyeLine,
                                color:
                                    context.theme.textTheme.bodyMedium!.color,
                                size: AppTextTheme.body1,
                              ),
                            ),
                            Text(
                              S.of(context).searchForSomething,
                            ),
                          ],
                        ),
                        onTap: () {
                          AppRouterDelegate.instance.currentBeamState
                              .updateWith(
                            showSearch: true,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
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
  final TickerProvider vsync;

  @override
  bool shouldRebuild(covariant _HomeAppBarDelegate oldDelegate) {
    return vsync != oldDelegate.vsync ||
        minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight;
  }
}

class _HomeAppBarUserInfo extends StatelessWidget {
  const _HomeAppBarUserInfo({required this.userInfo});

  final UserInfoModel userInfo;

  String? get name =>
      userInfo.user.nickname.strictValue ??
      userInfo.user.publicName.strictValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Instances.scaffoldStateKey.currentState?.openDrawer();
            },
            child: CircleAvatar(
              backgroundColor: context.theme.cardColor,
              child: Text(
                name?.substring(0, 1).toUpperCase() ?? '-',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
          ),
          Gap(direction: GapDirection.horizontal),
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
}

class _BannerCarouselItem extends StatelessWidget {
  const _BannerCarouselItem({super.key, required this.homeBanner});

  final HomeBannerModel homeBanner;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ExtendedImage.memory(
          homeBanner.bytes,
          fit: BoxFit.fill,
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
            color: (homeBanner.primaryColor ??
                    context.theme.colorScheme.background)
                .withOpacity(0.2),
            child: DefaultTextStyle(
              style: context.theme.textTheme.titleMedium!.copyWith(
                color: homeBanner.textColor,
              ),
              child: Text(homeBanner.title),
            ),
          ),
        ),
      ],
    );
  }
}
