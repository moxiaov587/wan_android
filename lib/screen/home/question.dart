part of 'home.dart';

class _QA extends StatefulWidget {
  const _QA({Key? key}) : super(key: key);

  @override
  State<_QA> createState() => _QAState();
}

class _QAState extends State<_QA> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshListViewWidget<
        StateNotifierProvider<QuestionNotifier,
            RefreshListViewState<ArticleModel>>,
        ArticleModel>(
      provider: questionArticleProvider,
      onInitState: (Reader reader) {
        reader.call(questionArticleProvider.notifier).initData();
      },
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
    );
  }
}
