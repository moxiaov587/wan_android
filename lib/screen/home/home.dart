import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/provider/view_state.dart';
import '../../../app/provider/widget/provider_widget.dart';
import '../../../widget/view_state_widget.dart';
import '../../contacts/icon_font_icons.dart';
import '../../contacts/instances.dart';
import '../../model/models.dart';
import '../../navigator/route_name.dart';
import '../../widget/custom_bottom_navigation_bar.dart';
import 'provider/home_provider.dart';

part 'project.dart';
part 'question.dart';
part 'square.dart';

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

  late final int _initialIndex;

  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  final PageController _pageController = PageController();

  @override
  void initState() {
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      _initialIndex = RouterName.homeTabsPath.indexOf(widget.initialPath);
      if (_initialIndex == -1) {
        _pageController.jumpToPage(0);
      } else {
        _pageController.jumpToPage(_initialIndex);
      }
    });
    super.initState();
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
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        itemBuilder: (_, int index) => _pages[index],
        onPageChanged: (int value) {
          _currentIndexNotifier.value = value;
          Beamer.of(context).update(
            configuration: RouteInformation(
              location: RouterName.homeTabsPath[value],
            ),
            rebuild: false,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(IconFontIcons.homeLine),
                activeIcon: Icon(
                  IconFontIcons.homeFill,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Square',
                icon: Icon(IconFontIcons.seedlingLine),
                activeIcon: Icon(
                  IconFontIcons.seedlingFill,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Q&A',
                icon: Icon(IconFontIcons.questionnaireLine),
                activeIcon: Icon(
                  IconFontIcons.questionnaireFill,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Project',
                icon: Icon(IconFontIcons.androidLine),
                activeIcon: Icon(
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
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: RefreshListViewWidget<
          StateNotifierProvider<ArticleNotifier,
              RefreshListViewState<ArticleModel>>,
          ArticleModel>(
        onInitState: (Reader reader) {
          reader.call(homeArticleProvider.notifier).initData();
        },
        provider: homeArticleProvider,
        builder: (_, __, List<ArticleModel> list) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                return ListTile(
                  title: Text(list[index].title),
                );
              },
              childCount: list.length,
            ),
          );
        },
      ),
    );
  }
}
