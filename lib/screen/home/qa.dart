part of 'home_screen.dart';

class _QA extends StatefulWidget {
  const _QA();

  @override
  State<_QA> createState() => _QAState();
}

class _QAState extends State<_QA> with AutomaticKeepAliveClientMixin {
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
          title: Text(S.of(context).question),
        ),
        Expanded(
          child: RefreshListViewWidget<
              StateNotifierProvider<QuestionNotifier,
                  RefreshListViewState<ArticleModel>>,
              ArticleModel>(
            provider: questionArticleProvider,
            onInitState: (Reader reader) {
              reader.call(questionArticleProvider.notifier).initData();
            },
            itemBuilder: (_, __, ___, ArticleModel article) {
              return ArticleTile(
                key: ValueKey<String>(
                  'qa_article_${article.id}',
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
