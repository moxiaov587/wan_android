part of 'my_collections_screen.dart';

class _Article extends ConsumerStatefulWidget {
  const _Article();

  @override
  __ArticleState createState() => __ArticleState();
}

class __ArticleState extends ConsumerState<_Article>
    with AutomaticKeepAliveClientMixin, RouteAware {
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Instances.routeObserver.subscribe(this, ModalRoute.of<dynamic>(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();

    ref.read(myCollectedArticleProvider.notifier).onSwitchCollectComplete();
  }

  @override
  void dispose() {
    Instances.routeObserver.unsubscribe(this);
    super.dispose();
  }

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
      builder: (_, Widget child) => SlidableAutoCloseBehavior(child: child),
      itemBuilder: (_, __, ___, CollectedArticleModel article) =>
          article.collect
              ? _CollectedArticleTile(
                  key: Key(
                    'my_collections_article_${article.id}',
                  ),
                  article: article,
                )
              : nil,
      separatorBuilder: (_, __, ___) => const Divider(),
    );
  }
}

class _CollectedArticleTile extends ConsumerWidget {
  const _CollectedArticleTile({super.key, required this.article});

  final CollectedArticleModel article;

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

    return Slidable(
      key: key,
      groupTag: CollectionType.article.name,
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
                  triggerCompleteCallback: true,
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
                        style: context.theme.textTheme.bodyMedium,
                        children: <TextSpan>[
                          if (article.author.strictValue != null)
                            TextSpan(
                              text: article.author.strictValue,
                            ),
                          if (article.author.strictValue != null) _textSpace,
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
                      style: context.theme.textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
