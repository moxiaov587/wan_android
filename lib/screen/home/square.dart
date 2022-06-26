part of 'home_screen.dart';

class _Square extends StatefulWidget {
  const _Square();

  @override
  State<_Square> createState() => _SquareState();
}

class _SquareState extends State<_Square> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: <Widget>[
        AppBar(
          leading: nil,
          leadingWidth: 0.0,
          title: Text(S.of(context).square),
        ),
        Expanded(
          child: RefreshListViewWidget<
              StateNotifierProvider<SquareNotifier,
                  RefreshListViewState<ArticleModel>>,
              ArticleModel>(
            provider: squareArticleProvider,
            onInitState: (Reader reader) {
              reader.call(squareArticleProvider.notifier).initData();
            },
            itemBuilder: (_, __, ___, ArticleModel article) {
              return ArticleTile(
                key: ValueKey<String>(
                  'square_article_${article.id}',
                ),
                article: article,
              );
            },
            separatorBuilder: (_, __, ___) => const Divider(),
          ),
        ),
      ],
    );
  }
}
