import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/provider/view_state.dart';
import '../../../app/provider/widget/provider_widget.dart';
import '../../model/article_model.dart';
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
        ));
  }
}
