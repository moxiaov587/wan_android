import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../app/provider/view_state.dart';
import '../../../app/provider/widget/provider_widget.dart';
import '../../../database/hive_boxes.dart';
import '../../../widget/view_state_widget.dart';
import '../../app/l10n/generated/l10n.dart';
import '../../app/theme/theme.dart';
import '../../contacts/icon_font_icons.dart';
import '../../contacts/instances.dart';
import '../../database/model/models.dart' show SearchHistory;
import '../../model/models.dart';
import '../../navigator/route_name.dart';
import '../../navigator/router_delegate.dart';
import '../../utils/dialog.dart';
import '../../utils/html_parse.dart';
import '../../widget/article.dart';
import '../../widget/capsule_ink.dart';
import '../../widget/custom_bottom_navigation_bar.dart';
import '../../widget/custom_search_delegate.dart';
import '../../widget/custom_sliver_child_builder_delegate.dart';
import '../../widget/gap.dart';
import '../drawer/drawer.dart';
import 'provider/home_provider.dart';

part 'project.dart';
part 'question.dart';
part 'search.dart';
part 'square.dart';

const String kSearchOriginParams = 'origin';

const double _kExpandedHeight = 200.0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.initialPath,
  }) : super(key: key);

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
          context.currentBeamLocation.state.routeInformation.location)) {
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
        itemBuilder: (_, int index) => Builder(
          builder: (BuildContext context) => Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              top: false,
              child: _pages[index],
            ),
          ),
        ),
        onPageChanged: (int value) {
          _currentIndexNotifier.value = value;
          AppRouterDelegate.instance.currentBeamState.updateWith(
            initialPath: RouterName.homeTabsPath[value],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: S.of(context).search,
        onPressed: () {
          AppRouterDelegate.instance.currentBeamState.updateWith(
            showSearch: true,
          );
        },
        child: const Icon(IconFontIcons.searchEyeLine),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ValueListenableBuilder<int>(
          valueListenable: _currentIndexNotifier,
          builder: (BuildContext context, int index, _) =>
              CustomBottomNavigationBar(
            currentIndex: index,
            onTap: (int value) {
              /// The [jumpToPage] will trigger [onPageChanged]
              _pageController.jumpToPage(value);
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: S.of(context).home,
                icon: const Icon(IconFontIcons.homeLine),
                activeIcon: const Icon(
                  IconFontIcons.homeFill,
                ),
              ),
              BottomNavigationBarItem(
                label: S.of(context).square,
                icon: const Icon(IconFontIcons.seedlingLine),
                activeIcon: const Icon(
                  IconFontIcons.seedlingFill,
                ),
              ),
              BottomNavigationBarItem(
                label: S.of(context).question,
                icon: const Icon(IconFontIcons.questionnaireLine),
                activeIcon: const Icon(
                  IconFontIcons.questionnaireFill,
                ),
              ),
              BottomNavigationBarItem(
                label: S.of(context).project,
                icon: const Icon(IconFontIcons.androidLine),
                activeIcon: const Icon(
                  IconFontIcons.androidFill,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({Key? key}) : super(key: key);

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> with AutomaticKeepAliveClientMixin {
  final ValueNotifier<bool> _showAppBar = ValueNotifier<bool>(false);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.axisDirection == AxisDirection.down &&
            notification.metrics.pixels > _kExpandedHeight &&
            !_showAppBar.value) {
          _showAppBar.value = true;
        } else if (notification.metrics.axisDirection == AxisDirection.down &&
            notification.metrics.pixels < _kExpandedHeight &&
            _showAppBar.value) {
          _showAppBar.value = false;
        }
        return false;
      },
      child: RefreshListViewWidget<
          StateNotifierProvider<ArticleNotifier,
              RefreshListViewState<ArticleModel>>,
          ArticleModel>(
        provider: homeArticleProvider,
        onInitState: (Reader reader) {
          reader.call(homeBannerProvider.notifier).initData();
          reader.call(homeArticleProvider.notifier).initData();
        },
        builder: (_, __, List<ArticleModel> list) {
          return SliverList(
            delegate: CustomSliverChildBuilderDelegate.separated(
              itemBuilder: (_, int index) {
                return ArticleTile(
                  article: list[index],
                );
              },
              itemCount: list.length,
            ),
          );
        },
        slivers: <Widget>[
          SliverAppBar(
            leading: const SizedBox.shrink(),
            leadingWidth: 0.0,
            pinned: true,
            expandedHeight: _kExpandedHeight,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: ValueListenableBuilder<bool>(
                valueListenable: _showAppBar,
                builder: (_, bool show, Widget? child) {
                  return show
                      ? Text(
                          S.of(context).appName,
                          style: currentTheme.textTheme.titleLarge,
                        )
                      : child!;
                },
                child: const SizedBox.shrink(),
              ),
              background: Consumer(
                builder: (_, WidgetRef ref, __) {
                  return ref.watch(homeBannerProvider).when(
                        (List<BannerModel> list) =>
                            ExtendedImageGesturePageView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return _BannerCarouselItem(
                              image: ExtendedImage.network(
                                list[index].imagePath,
                                fit: BoxFit.fill,
                                height: 200.0,
                              ),
                              title: list[index].title,
                            );
                          },
                          itemCount: list.length,
                        ),
                        loading: () => const SizedBox(
                          height: _kExpandedHeight,
                          child: LoadingWidget(),
                        ),
                        error: (int? statusCode, String? message,
                                String? detail) =>
                            SizedBox(
                          height: _kExpandedHeight,
                          child: Ink(
                            child: InkWell(
                              onTap: () {
                                ref
                                    .read(homeBannerProvider.notifier)
                                    .initData();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    IconFontIcons.refreshLine,
                                    color:
                                        currentTheme.textTheme.bodySmall!.color,
                                    size: 36.0,
                                  ),
                                  Gap(
                                    size: GapSize.big,
                                  ),
                                  Text(
                                      '${message ?? detail ?? S.of(context).unknownError}(${statusCode ?? -1})'),
                                  Gap(),
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
        ],
      ),
    );
  }
}

class _BannerCarouselItem extends StatefulWidget {
  const _BannerCarouselItem({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  final ExtendedImage image;

  final String title;

  @override
  __BannerCarouselItemState createState() => __BannerCarouselItemState();
}

class __BannerCarouselItemState extends State<_BannerCarouselItem> {
  final ValueNotifier<List<Color?>> colorsNotifier =
      ValueNotifier<List<Color?>>(<Color?>[null, null]);

  @override
  void initState() {
    super.initState();

    PaletteGenerator.fromImageProvider(
      widget.image.image,
      maximumColorCount: 20,
    ).then((PaletteGenerator paletteGenerator) {
      colorsNotifier.value = <Color?>[
        paletteGenerator.vibrantColor?.color,
        paletteGenerator.vibrantColor?.titleTextColor,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        widget.image,
        Positioned(
          left: 0.0,
          bottom: 0.0,
          child: ValueListenableBuilder<List<Color?>>(
            valueListenable: colorsNotifier,
            builder: (_, List<Color?> colors, Widget? child) {
              return Container(
                padding: const EdgeInsets.only(
                  right: 16.0,
                ),
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                color: colors.first?.withOpacity(.2) ??
                    currentTheme.backgroundColor.withOpacity(.2),
                child: DefaultTextStyle(
                  style: currentTheme.textTheme.titleMedium!.copyWith(
                    color: colors.last,
                  ),
                  child: child!,
                ),
              );
            },
            child: Text(widget.title),
          ),
        ),
      ],
    );
  }
}
