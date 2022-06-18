part of 'my_collections_screen.dart';

class _Article extends StatefulWidget {
  const _Article();

  @override
  __ArticleState createState() => __ArticleState();
}

class __ArticleState extends State<_Article>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AutoDisposeRefreshListViewWidget<
        AutoDisposeStateNotifierProvider<MyCollectedArticleNotifier,
            RefreshListViewState<CollectedArticleModel>>,
        CollectedArticleModel>(
      provider: myCollectedArticleProvider,
      onInitState: (Reader reader) {
        reader.call(myCollectedArticleProvider.notifier).initData();
      },
      builder: (_, WidgetRef ref, int index, __) {
        return ProviderScope(
          overrides: <Override>[
            _currentArticleProvider.overrideWithValue(
              ref.watch(myCollectedArticleProvider).whenOrNull(
                    (_, __, List<CollectedArticleModel> list) => list[index],
                  ),
            ),
          ],
          child: const _CollectedArticleTile(),
        );
      },
    );
  }
}

final AutoDisposeProvider<CollectedArticleModel?> _currentArticleProvider =
    Provider.autoDispose<CollectedArticleModel?>(
  (_) => null,
);

class _CollectedArticleTile extends ConsumerWidget {
  const _CollectedArticleTile();

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

    final CollectedArticleModel? article = ref.read(_currentArticleProvider);

    return article != null && article.collect
        ? Slidable(
            groupTag: CollectionType.article.name,
            key: key,
            endActionPane: ActionPane(
              extentRatio: 0.25,
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                closeOnCancel: true,
                dismissThreshold: 0.65,
                dismissalDuration: const Duration(milliseconds: 500),
                onDismissed: () {
                  ref.read(myCollectedArticleProvider.notifier).switchCollect(
                        article.id,
                        changedValue: false,
                      );
                },
                confirmDismiss: () => ref
                    .read(myCollectedArticleProvider.notifier)
                    .requestCancelCollect(
                      collectId: article.id,
                      articleId: article.originId,
                    ),
              ),
              children: <Widget>[
                DismissibleSlidableAction(
                  slidableExtentRatio: 0.25,
                  dismissiblePaneThreshold: 0.65,
                  label: S.of(context).edit,
                  onTap: () {
                    AppRouterDelegate.instance.currentBeamState.updateWith(
                      showHandleCollectedBottomSheet: true,
                      collectionTypeIndex: CollectionType.article.index,
                      collectId: article.id,
                    );
                  },
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: ScreenUtils.width,
                height: 94.0,
              ),
              child: Material(
                child: Ink(
                  child: InkWell(
                    onTap: () {
                      AppRouterDelegate.instance.currentBeamState.updateWith(
                        articleId: article.id,
                      );
                    },
                    child: Padding(
                      padding: AppTheme.bodyPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              style: currentTheme.textTheme.bodyMedium,
                              children: <TextSpan>[
                                if (article.author.strictValue != null)
                                  TextSpan(
                                    text: article.author.strictValue,
                                  ),
                                if (article.author.strictValue != null)
                                  _textSpace,
                                TextSpan(
                                  text: article.niceDate,
                                ),
                                if (article.chapterName.strictValue != null)
                                  _textSpace,
                                if (article.chapterName.strictValue != null)
                                  TextSpan(
                                    text: article.chapterName.strictValue,
                                  ),
                              ],
                            ),
                          ),
                          Gap(
                            value: titleVerticalGap,
                          ),
                          Text(
                            HTMLParseUtils.parseArticleTitle(
                                  title: article.title,
                                ) ??
                                S.of(context).unknown,
                            style: currentTheme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : nil;
  }
}
