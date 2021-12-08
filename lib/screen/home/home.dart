import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/provider/view_state.dart';
import '../../../app/provider/widget/provider_widget.dart';
import '../../contacts/icon_font_icons.dart';
import '../../contacts/instances.dart';
import '../../model/article_model.dart';
import '../../widget/custom_bottom_navigation_bar.dart';
import '../../widget/refresh_list_footer.dart';
import 'home_article_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.onTapped,
  }) : super(key: key);

  final ValueChanged<String> onTapped;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: RefreshListViewWidget<
          StateNotifierProvider<ArticleNotifier,
              RefreshListViewState<ArticleModel>>,
          ArticleModel>(
        model: homeArticleProvider,
        builder: (_, __, List<ArticleModel> list) {
          return ListView.separated(
            itemBuilder: (___, int index) {
              return ListTile(
                title: Text(list[index].title),
              );
            },
            separatorBuilder: (____, _____) => const Divider(),
            itemCount: list.length,
          );
        },
        footer: RefreshListFooter(
          marginBottom: (currentTheme
                      .floatingActionButtonTheme.sizeConstraints?.minHeight ??
                  0.0) /
              2,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(IconFontIcons.searchEyeLine),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ValueListenableBuilder<int>(
          valueListenable: _currentIndexNotifier,
          builder: (_, int index, __) => CustomBottomNavigationBar(
            currentIndex: index,
            onTap: (int value) => _currentIndexNotifier.value = value,
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
