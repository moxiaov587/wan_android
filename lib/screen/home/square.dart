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

    return Column(
      children: <Widget>[
        AppBar(
          leading: const SizedBox.shrink(),
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
