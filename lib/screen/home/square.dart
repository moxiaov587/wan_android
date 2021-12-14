part of 'home.dart';

class _Square extends StatefulWidget {
  const _Square({Key? key}) : super(key: key);

  @override
  State<_Square> createState() => _SquareState();
}

class _SquareState extends State<_Square> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshListViewWidget<
        StateNotifierProvider<SquareNotifier,
            RefreshListViewState<ArticleModel>>,
        ArticleModel>(
      model: squareArticleProvider,
      onInitState: (Reader reader) {
        reader.call(squareArticleProvider.notifier).initData();
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