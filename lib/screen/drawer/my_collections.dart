part of 'drawer.dart';

class MyCollectionsScreen extends StatelessWidget {
  const MyCollectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myCollections),
      ),
      body: SafeArea(
        child: AutoDisposeRefreshListViewWidget<
            AutoDisposeStateNotifierProvider<MyCollectionsNotifier,
                RefreshListViewState<CollectModel>>,
            CollectModel>(
          provider: myCollectionsProvider,
          onInitState: (Reader reader) {
            reader.call(myCollectionsProvider.notifier).initData();
          },
          builder: (_, __, List<CollectModel> list) {
            return SliverList(
              delegate: CustomSliverChildBuilderDelegate.separated(
                itemBuilder: (_, int index) {
                  return CollectTile(
                    index: index,
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

class CollectTile extends ConsumerWidget {
  const CollectTile({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  TextSpan get _textSpace => const TextSpan(
        text: '${Unicode.halfWidthSpace}•${Unicode.halfWidthSpace}',
        style: TextStyle(
          wordSpacing: kStyleUint / 2,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EdgeInsetsGeometry contentPadding = AppTheme.bodyPadding;

    final double titleVerticalGap = contentPadding.vertical / 2;

    final CollectModel collect = ref
        .read(myCollectionsProvider)
        .whenOrNull((_, __, List<CollectModel> list) => list[index])!;

    return Material(
      child: Ink(
        child: InkWell(
          onTap: () {
            AppRouterDelegate.instance.currentBeamState.updateWith(
              articleId: collect.id,
            );
          },
          child: Padding(
            padding: AppTheme.bodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Builder(builder: (_) {
                  final bool collected = ref.watch(myCollectionsProvider.select(
                      (RefreshListViewState<CollectModel> value) =>
                          value.whenOrNull((_, __, List<CollectModel> list) =>
                              list[index].collect) ??
                          true));
                  return RichText(
                    text: TextSpan(
                      text: collect.author.strictValue ??
                          S.of(context).unknownAuthor,
                      style: currentTheme.textTheme.bodyMedium!.copyWith(
                        decoration:
                            collected ? null : TextDecoration.lineThrough,
                      ),
                      children: <TextSpan>[
                        _textSpace,
                        TextSpan(
                          text: collect.niceDate,
                        ),
                        _textSpace,
                        TextSpan(
                          text: collect.chapterName ?? '',
                        )
                      ],
                    ),
                  );
                }),
                Gap(
                  value: titleVerticalGap,
                ),
                Builder(builder: (_) {
                  final bool collected = ref.watch(myCollectionsProvider.select(
                      (RefreshListViewState<CollectModel> value) =>
                          value.whenOrNull((_, __, List<CollectModel> list) =>
                              list[index].collect) ??
                          true));

                  return Text(
                    collect.title ?? S.of(context).unknownArticleTitle,
                    style: currentTheme.textTheme.titleSmall!.copyWith(
                      decoration: collected ? null : TextDecoration.lineThrough,
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
