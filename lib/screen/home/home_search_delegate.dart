part of 'home_screen.dart';

const int _kMaxNumOfSearchHistory = 8;

class HomeSearchDelegate extends CustomSearchDelegate<void> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: kToolbarPadding),
        child: TextButton(
          child: Text(
            S.of(context).cancel,
            style: context.theme.textTheme.titleLarge!.copyWith(
              color: context.theme.primaryColor,
              fontSize: 16.0,
            ),
          ),
          onPressed: () {
            close(context, null);
          },
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  void showResults(BuildContext context) {
    if (query.isNotEmpty) {
      super.showResults(context);
    } else {
      DialogUtils.waring(S.of(context).keywordEmptyTips);
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    return _Results(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _Suggestions(
      onTap: (String keyword) {
        query = keyword;
        showResults(context);
      },
    );
  }
}

class _Results extends ConsumerStatefulWidget {
  const _Results({required this.query});

  final String query;

  @override
  ConsumerState<_Results> createState() => __ResultsState();
}

class __ResultsState extends ConsumerState<_Results>
    with
        AutoDisposeRefreshListViewStateMixin<
            AutoDisposeStateNotifierProvider<SearchNotifier,
                RefreshListViewState<ArticleModel>>,
            ArticleModel,
            _Results> {
  Isar get isar => ref.read(appDatabaseProvider);

  @override
  void initState() {
    super.initState();

    addSearchHistory();
  }

  void addSearchHistory() {
    final int length = isar.searchHistoryCaches.countSync();

    final SearchHistory? duplicateSearchHistory = isar.searchHistoryCaches
        .filter()
        .keywordEqualTo(widget.query)
        .findFirstSync();

    int? id;

    if (length == _kMaxNumOfSearchHistory) {
      id = isar.searchHistoryCaches
          .where()
          .sortByUpdateTime()
          .findFirstSync()
          ?.id;
    }

    final SearchHistory searchHistory = SearchHistory()
      ..keyword = widget.query
      ..updateTime = DateTime.now();

    if (duplicateSearchHistory != null) {
      searchHistory.id = duplicateSearchHistory.id;
    }

    isar.writeTxnSync<void>(
      () {
        if (id != null) {
          isar.searchHistoryCaches.deleteSync(id);
        }

        isar.searchHistoryCaches.putSync(searchHistory);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: CustomScrollView(
        slivers: <Widget>[
          pullDownIndicator,
          Consumer(
            builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
              (
                int nextPageNum,
                bool isLastPage,
                List<ArticleModel> list,
              ) {
                if (list.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyWidget(),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: ScreenUtils.bottomSafeHeight,
                  ),
                  sliver: LoadMoreSliverList.separator(
                    loadMoreIndicatorBuilder: loadMoreIndicatorBuilder,
                    itemBuilder: (_, int index) {
                      final ArticleModel article = list[index];

                      return ArticleTile(
                        key: Key('search_article_${article.id}'),
                        article: article,
                        query: widget.query,
                      );
                    },
                    separatorBuilder: (_, __) => const IndentDivider(),
                    itemCount: list.length,
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

  @override
  late final AutoDisposeStateNotifierProvider<SearchNotifier,
          RefreshListViewState<ArticleModel>> provider =
      searchArticlesProvider(widget.query);
}

typedef SearchHistoryCallback = Function(String keyword);

class _Suggestions extends ConsumerStatefulWidget {
  const _Suggestions({required this.onTap});

  final SearchHistoryCallback onTap;

  @override
  __SuggestionsState createState() => __SuggestionsState();
}

class __SuggestionsState extends ConsumerState<_Suggestions> {
  Isar get isar => ref.read(appDatabaseProvider);

  @override
  Widget build(BuildContext context) {
    final double wrapSpace = AppTheme.bodyPadding.top;

    return CustomScrollView(
      slivers: <Widget>[
        StreamBuilder<List<SearchHistory>>(
          stream: isar.searchHistoryCaches
              .where()
              .sortByUpdateTimeDesc()
              .build()
              .watch(fireImmediately: true),
          builder: (_, AsyncSnapshot<List<SearchHistory>> snapshot) {
            final List<SearchHistory> keywords =
                snapshot.data ?? <SearchHistory>[];

            if (keywords.isEmpty) {
              return const SliverToBoxAdapter(child: nil);
            }

            return SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: AppTheme.bodyPaddingOnlyHorizontal,
                        child: Text(
                          S.of(context).searchHistory,
                          style: context.theme.textTheme.titleSmall,
                        ),
                      ),
                      IconButton(
                        padding: AppTheme.bodyPaddingOnlyHorizontal,
                        onPressed: () {
                          isar.writeTxnSync(
                            () => isar.searchHistoryCaches.clearSync(),
                          );
                        },
                        icon: const Icon(
                          IconFontIcons.deleteLine,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: AppTheme.bodyPaddingOnlyHorizontal,
                    child: Wrap(
                      spacing: wrapSpace,
                      runSpacing: wrapSpace,
                      children: keywords
                          .map(
                            (SearchHistory e) => CapsuleInk(
                              child: Text(e.keyword),
                              onTap: () {
                                widget.onTap.call(e.keyword);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SliverPadding(
          padding: AppTheme.bodyPadding,
          sliver: SliverToBoxAdapter(
            child: Text(
              S.of(context).popularKeyword,
              style: context.theme.textTheme.titleSmall,
            ),
          ),
        ),
        SliverPadding(
          padding: AppTheme.bodyPaddingOnlyHorizontal,
          sliver: Consumer(
            builder: (_, WidgetRef ref, Widget? loadingWidget) {
              return SliverToBoxAdapter(
                child: Wrap(
                  spacing: wrapSpace,
                  runSpacing: wrapSpace,
                  children: ref.watch(searchPopularKeywordProvider).when(
                        data: (List<SearchKeywordModel> list) => list
                            .map(
                              (SearchKeywordModel e) => CapsuleInk(
                                child: Text(e.name),
                                onTap: () {
                                  widget.onTap.call(e.name);
                                },
                              ),
                            )
                            .toList(),
                        loading: () => <Widget>[
                          loadingWidget!,
                        ],
                        error: (_, __) => <Widget>[
                          CapsuleInk(
                            onTap: () {
                              ref.invalidate(searchPopularKeywordProvider);
                            },
                            child: const Icon(
                              IconFontIcons.refreshLine,
                              size: 16.0,
                            ),
                          ),
                        ],
                      ),
                ),
              );
            },
            child: const CapsuleInk(
              child: CupertinoActivityIndicator(
                radius: 7.0,
              ),
            ),
          ),
        ),
      ],
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    );
  }
}
