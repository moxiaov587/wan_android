part of 'home_screen.dart';

class HomeSearchDelegate extends CustomSearchDelegate<void> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      TextButton(
        style: ButtonStyle(
          padding: ButtonStyleButton.allOrNull<EdgeInsets>(
            const EdgeInsets.fromLTRB(
              0.0,
              kStyleUint2,
              kStyleUint3,
              kStyleUint2,
            ),
          ),
          overlayColor: ButtonStyleButton.allOrNull<Color>(
            Colors.transparent,
          ),
        ),
        child: Text(
          S.of(context).cancel,
          style: currentTheme.textTheme.titleLarge!.copyWith(
            color: currentTheme.primaryColor,
            fontSize: 16.0,
          ),
        ),
        onPressed: () {
          close(context, null);
        },
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
    addSearchHistory();

    final AutoDisposeStateNotifierProvider<SearchNotifier,
            RefreshListViewState<ArticleModel>> provider =
        searchArticlesProvider(query);

    return AutoDisposeRefreshListViewWidget<
        AutoDisposeStateNotifierProvider<SearchNotifier,
            RefreshListViewState<ArticleModel>>,
        ArticleModel>(
      provider: provider,
      onInitState: (Reader reader) {
        reader.call(provider.notifier).initData();
      },
      builder: (_, __, ___, ArticleModel article) {
        return ArticleTile(
          key: ValueKey<String>(
            'search_article_${article.id}',
          ),
          article: article,
          query: query,
        );
      },
    );
  }

  Future<void> addSearchHistory() async {
    final int length = HiveBoxes.searchHistoryBox.length;

    final dynamic key = HiveBoxes.searchHistoryBox.values
        .firstWhereOrNull((SearchHistory element) => element.keyword == query)
        ?.key;
    if (length == 5) {
      if (key != null) {
        await HiveBoxes.searchHistoryBox.delete(key);
        await HiveBoxes.searchHistoryBox.add(SearchHistory(keyword: query));
      } else {
        await HiveBoxes.searchHistoryBox.deleteAt(0);
        await HiveBoxes.searchHistoryBox.add(SearchHistory(keyword: query));
      }
    } else {
      if (key != null) {
        await HiveBoxes.searchHistoryBox.delete(key);
        await HiveBoxes.searchHistoryBox.add(SearchHistory(keyword: query));
      } else {
        await HiveBoxes.searchHistoryBox.add(SearchHistory(keyword: query));
      }
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: onSuggestionsScrollNotification,
      child: _Suggestions(
        onInitData: (Reader reader) {
          reader.call(searchHistoryProvider.notifier).initData();
          reader.call(searchPopularKeywordProvider.notifier).initData();
        },
        onTap: (String keyword) {
          query = keyword;
          showResults(context);
        },
      ),
    );
  }
}

typedef SearchHistoryCallback = Function(String keyword);

class _Suggestions extends ConsumerStatefulWidget {
  const _Suggestions({
    required this.onTap,
    this.onInitData,
  });

  final SearchHistoryCallback onTap;

  final ReaderCallback? onInitData;

  @override
  __SuggestionsState createState() => __SuggestionsState();
}

class __SuggestionsState extends ConsumerState<_Suggestions> {
  @override
  void initState() {
    super.initState();

    widget.onInitData?.call(ref.read);
  }

  @override
  Widget build(BuildContext context) {
    const Widget searchHistoryEmpty = SliverToBoxAdapter(
      child: nil,
    );

    final double wrapSpace = AppTheme.bodyPaddingOnlyVertical.vertical / 2;

    return CustomScrollView(
      slivers: <Widget>[
        ref.watch(searchHistoryProvider).whenOrNull(
              (List<SearchHistory> list) {
                return list.isEmpty
                    ? searchHistoryEmpty
                    : SliverPadding(
                        padding: AppTheme.bodyPaddingOnlyHorizontal,
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    S.of(context).searchHistory,
                                    style: currentTheme.textTheme.titleSmall,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.centerRight,
                                    splashColor: Colors.transparent,
                                    onPressed: () async {
                                      await HiveBoxes.searchHistoryBox.clear();
                                      ref
                                          .read(searchHistoryProvider.notifier)
                                          .initData();
                                    },
                                    icon: const Icon(
                                      IconFontIcons.deleteLine,
                                    ),
                                  ),
                                ],
                              ),
                              Wrap(
                                spacing: wrapSpace,
                                runSpacing: wrapSpace,
                                children: list.reversed
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
                            ],
                          ),
                        ),
                      );
              },
            ) ??
            searchHistoryEmpty,
        SliverPadding(
          padding: AppTheme.bodyPadding,
          sliver: SliverToBoxAdapter(
            child: Text(
              S.of(context).popularKeyword,
              style: currentTheme.textTheme.titleSmall,
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
                        (List<SearchKeywordModel> list) => list
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
                        error: (_, __, ___) => <Widget>[
                          CapsuleInk(
                            onTap: ref
                                .read(searchPopularKeywordProvider.notifier)
                                .initData,
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
    );
  }
}
