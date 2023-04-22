part of 'home_screen.dart';

const int _kMaxNumOfSearchHistory = 8;

class HomeSearchDelegate extends CustomSearchDelegate<void> {
  @override
  List<Widget>? buildActions(BuildContext context) => <Widget>[
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

  @override
  Widget? buildLeading(BuildContext context) => null;

  @override
  void showResults(BuildContext context) {
    if (query.isNotEmpty) {
      super.showResults(context);
    } else {
      DialogUtils.waring(S.of(context).keywordEmptyTips);
    }
  }

  @override
  Widget buildResults(BuildContext context) => _Results(query: query);

  @override
  Widget buildSuggestions(BuildContext context) => _Suggestions(
        onTap: (String keyword) {
          query = keyword;
          showResults(context);
        },
      );
}

class _Results extends ConsumerStatefulWidget {
  const _Results({required this.query});

  final String query;

  @override
  ConsumerState<_Results> createState() => __ResultsState();
}

class __ResultsState extends ConsumerState<_Results>
    with
        RefreshListViewStateMixin<SearchArticleProvider, ArticleModel,
            _Results> {
  @override
  late final SearchArticleProvider provider =
      searchArticleProvider(widget.query);

  @override
  PaginationDataRefreshable<ArticleModel> get refreshable => provider.future;

  @override
  Future<LoadingMoreStatus?> loadMore() =>
      ref.read(provider.notifier).loadMore();

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

    unawaited(
      isar.writeTxn<dynamic>(
        () async {
          if (id != null) {
            await isar.searchHistoryCaches.delete(id);
          }

          await isar.searchHistoryCaches.put(searchHistory);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: CustomScrollView(
          slivers: <Widget>[
            pullDownIndicator,
            Consumer(
              builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                    data: (PaginationData<ArticleModel> data) {
                      final List<ArticleModel> list = data.datas;

                      if (list.isEmpty) {
                        return const SliverFillRemaining(
                          child: EmptyWidget.search(),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, int index) {
                            final ArticleModel article = list[index];

                            return ArticleTile(
                              key: Key('search_article_${article.id}'),
                              article: article,
                              query: widget.query,
                            );
                          },
                          childCount: list.length,
                        ),
                      );
                    },
                    loading: loadingIndicatorBuilder,
                    error: errorIndicatorBuilder,
                  ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: ScreenUtils.bottomSafeHeight),
              sliver: loadMoreIndicator,
            ),
          ],
        ),
      );
}

typedef SearchHistoryCallback = void Function(String keyword);

class _Suggestions extends ConsumerStatefulWidget {
  const _Suggestions({required this.onTap});

  final SearchHistoryCallback onTap;

  @override
  __SuggestionsState createState() => __SuggestionsState();
}

class __SuggestionsState extends ConsumerState<_Suggestions> {
  Isar get isar => ref.read(appDatabaseProvider);

  final ValueNotifier<bool> _loadingClearBtnNotifier =
      ValueNotifier<bool>(false);

  @override
  void dispose() {
    _loadingClearBtnNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double wrapSpace = AppTheme.bodyPadding.top;

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: StreamBuilder<List<SearchHistory>>(
            stream: isar.searchHistoryCaches
                .where()
                .sortByUpdateTimeDesc()
                .build()
                .watch(fireImmediately: true),
            builder: (_, AsyncSnapshot<List<SearchHistory>> snapshot) {
              final List<SearchHistory> keywords =
                  snapshot.data ?? <SearchHistory>[];

              if (keywords.isEmpty) {
                return nil;
              }

              return Column(
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
                      ValueListenableBuilder<bool>(
                        valueListenable: _loadingClearBtnNotifier,
                        builder: (
                          BuildContext context,
                          bool loading,
                          Widget? child,
                        ) =>
                            IconButton(
                          padding: AppTheme.bodyPaddingOnlyHorizontal,
                          tooltip: S.of(context).clear,
                          onPressed: loading
                              ? null
                              : () async {
                                  _loadingClearBtnNotifier.value = true;
                                  try {
                                    await isar.writeTxn(
                                      isar.searchHistoryCaches.clear,
                                    );
                                  } finally {
                                    _loadingClearBtnNotifier.value = false;
                                  }
                                },
                          icon: child!,
                        ),
                        child: const Icon(IconFontIcons.deleteLine),
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
              );
            },
          ),
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
          sliver: SliverToBoxAdapter(
            child: Consumer(
              builder: (_, WidgetRef ref, __) => Wrap(
                spacing: wrapSpace,
                runSpacing: wrapSpace,
                children: ref.watch(searchPopularKeywordProvider).when(
                      skipLoadingOnRefresh: false,
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
                      loading: () => const <Widget>[
                        CapsuleInk(
                          child: LoadingWidget.capsuleInk(),
                        ),
                      ],
                      error: (_, __) => <Widget>[
                        CapsuleInk(
                          onTap: () {
                            ref.invalidate(searchPopularKeywordProvider);
                          },
                          child: const Icon(IconFontIcons.refreshLine),
                        ),
                      ],
                    ),
              ),
            ),
          ),
        ),
      ],
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    );
  }
}
