part of 'my_collections_screen.dart';

class _Article extends ConsumerStatefulWidget {
  const _Article();

  @override
  __ArticleState createState() => __ArticleState();
}

class __ArticleState extends ConsumerState<_Article>
    with
        AutomaticKeepAliveClientMixin,
        RouteAware,
        AutoDisposeRefreshListViewStateMixin<MyCollectedArticleProvider,
            CollectedArticleModel, _Article> {
  @override
  bool get wantKeepAlive => true;

  @override
  MyCollectedArticleProvider get provider => myCollectedArticleProvider;

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

    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: CustomScrollView(
        slivers: <Widget>[
          pullDownIndicator,
          Consumer(
            builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
              (_, __, List<CollectedArticleModel> list) {
                list = list
                    .where((CollectedArticleModel article) => article.collect)
                    .toList();

                if (list.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyWidget.favorites(),
                  );
                }

                return SliverPadding(
                  padding:
                      EdgeInsets.only(bottom: ScreenUtils.bottomSafeHeight),
                  sliver: SlidableAutoCloseBehavior(
                    child: LoadMoreSliverList.separator(
                      loadMoreIndicatorBuilder: loadMoreIndicatorBuilder,
                      itemBuilder: (_, int index) {
                        final CollectedArticleModel article = list[index];

                        return _CollectedArticleTile(
                          key: Key('my_collections_article_${article.id}'),
                          article: article,
                        );
                      },
                      findChildIndexCallback: (Key key) {
                        final int index = list.indexWhere(
                          (CollectedArticleModel article) =>
                              key ==
                              Key('my_collections_article_${article.id}'),
                        );

                        if (index == -1) {
                          return null;
                        }

                        return index;
                      },
                      separatorBuilder: (_, __) => const IndentDivider(),
                      itemCount: list.length,
                    ),
                  ),
                );
              },
              loading: loadingIndicatorBuilder,
              error: errorIndicatorBuilder,
            ),
          ),
        ],
      ),
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
    return Slidable(
      key: key,
      groupTag: CollectionType.article.name,
      dragStartBehavior: DragStartBehavior.start,
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const StretchMotion(),
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
          confirmDismiss: () async {
            final bool? result = await DialogUtils.confirm<bool>(
              isDanger: true,
              builder: (BuildContext context) {
                return Text(S.of(context).removeArticleTips);
              },
              confirmCallback: () async {
                final bool result = await ref
                    .read(myCollectedArticleProvider.notifier)
                    .requestCancelCollect(
                      collectId: article.id,
                      articleId: article.originId,
                    );

                return result;
              },
            );

            return result ?? false;
          },
        ),
        children: <Widget>[
          DismissibleSlidableAction(
            slidableExtentRatio: 0.25,
            dismissiblePaneThreshold: 0.65,
            label: S.of(context).edit,
            onTap: () {
              EditCollectedArticleOrWebsiteRoute(
                type: CollectionType.article,
                id: article.id,
              ).push(context);
            },
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints:
            BoxConstraints.tightFor(width: ScreenUtils.width, height: 94.0),
        child: Material(
          child: Ink(
            child: InkWell(
              onTap: () {
                ArticleRoute(id: article.id).push(context);
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
                      value: AppTheme.bodyPadding.top,
                    ),
                    Text(
                      HTMLParseUtils.unescapeHTML(article.title) ??
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
