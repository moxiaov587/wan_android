part of 'they.dart';

class TheyArticlesScreen extends StatefulWidget {
  const TheyArticlesScreen({
    super.key,
    required this.author,
  });

  final String author;

  @override
  _TheyArticlesScreenState createState() => _TheyArticlesScreenState();
}

class _TheyArticlesScreenState extends State<TheyArticlesScreen> {
  late AutoDisposeStateNotifierProvider<TheyArticlesNotifier,
          RefreshListViewState<ArticleModel>> provider =
      theyArticlesProvider(widget.author);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).theyArticles),
      ),
      body: SafeArea(
        child: AutoDisposeRefreshListViewWidget<
            AutoDisposeStateNotifierProvider<TheyArticlesNotifier,
                RefreshListViewState<ArticleModel>>,
            ArticleModel>(
          provider: provider,
          onInitState: (Reader reader) {
            reader.call(provider.notifier).initData();
          },
          builder: (_, __, ___, ArticleModel article) {
            return ArticleTile(
              key: ValueKey<String>(
                'they_article_${article.id}',
              ),
              authorTextOrShareUserTextCanOnTap: false,
              article: article,
            );
          },
          separatorBuilder: (_, __, ___) => const Divider(),
        ),
      ),
    );
  }
}
