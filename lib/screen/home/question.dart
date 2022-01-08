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

    return Column(
      children: <Widget>[
        AppBar(
          leading: const SizedBox.shrink(),
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
            builder: (_, __, List<ArticleModel> list) {
              return SliverList(
                delegate: CustomSliverChildBuilderDelegate.separated(
                  itemBuilder: (_, int index) {
                    return ArticleTile(
                      article: list[index],
                    );
                  },
                  separatorBuilder: (_, int index) => const Divider(
                    indent: kStyleUint4,
                    endIndent: kStyleUint4,
                  ),
                  itemCount: list.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
