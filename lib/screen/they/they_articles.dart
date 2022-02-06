part of 'they.dart';

class TheyArticlesScreen extends StatefulWidget {
  const TheyArticlesScreen({
    Key? key,
    required this.author,
  }) : super(key: key);

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
          builder: (_, __, List<ArticleModel> list) {
            return SliverList(
              delegate: CustomSliverChildBuilderDelegate.separated(
                itemBuilder: (_, int index) {
                  return ArticleTile(
                    authorTextOrShareUserTextCanOnTap: false,
                    article: list[index],
                  );
                },
                itemCount: list.length,
              ),
            );
          },
        ),
      ),
    );
  }
}
