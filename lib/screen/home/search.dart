part of 'home.dart';

const double _kSuggestionsVerticalHeight = 12.0;

class HomeSearchDelegate extends CustomSearchDelegate<void> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      TextButton(
        style: ButtonStyle(
          padding: ButtonStyleButton.allOrNull<EdgeInsets>(
            const EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 8.0),
          ),
          overlayColor: ButtonStyleButton.allOrNull<Color>(
            Colors.transparent,
          ),
        ),
        child: Text(
          S.of(context).cancel,
          style: currentTheme.textTheme.headline6?.copyWith(
            color: currentTheme.primaryColor,
            fontSize: 16.0,
          ),
        ),
        onPressed: () {
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
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
      onInitState: (Reader reader) async {
        reader.call(provider.notifier).initData();
      },
      builder: (_, __, List<ArticleModel> list) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) {
              return ListTile(
                title: Text(list[index].title),
              );
            },
            childCount: list.length,
          ),
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
    Key? key,
    required this.onTap,
    this.onInitData,
  }) : super(key: key);

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
    const EdgeInsetsGeometry headerPadding = EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: _kSuggestionsVerticalHeight,
    );

    const EdgeInsetsGeometry bodyPadding = EdgeInsets.symmetric(
      horizontal: 16.0,
    );

    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: headerPadding,
          sliver: SliverToBoxAdapter(
            child: Text(
              S.of(context).searchHistory,
              style: currentTheme.textTheme.subtitle1,
            ),
          ),
        ),
        SliverPadding(
          padding: bodyPadding,
          sliver: SliverToBoxAdapter(
            child: Consumer(
              builder: (_, WidgetRef ref, Widget? child) {
                return ref
                        .watch(searchHistoryProvider)
                        .whenOrNull((List<SearchHistory> list) {
                      if (list.isEmpty) {
                        return child!;
                      } else {
                        return Wrap(
                          spacing: _kSuggestionsVerticalHeight,
                          runSpacing: _kSuggestionsVerticalHeight,
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
                        );
                      }
                    }) ??
                    child!;
              },
              child: Text(S.of(context).empty),
            ),
          ),
        ),
        SliverPadding(
          padding: headerPadding,
          sliver: SliverToBoxAdapter(
            child: Text(
              S.of(context).popularKeyword,
              style: currentTheme.textTheme.subtitle1,
            ),
          ),
        ),
        SliverPadding(
          padding: bodyPadding,
          sliver: Consumer(
            builder: (_, WidgetRef ref, Widget? loadingWidget) {
              return SliverToBoxAdapter(
                child: Wrap(
                  spacing: _kSuggestionsVerticalHeight,
                  runSpacing: _kSuggestionsVerticalHeight,
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
                            child: const Icon(
                              Icons.refresh,
                              size: 16.0,
                            ),
                            onTap: ref
                                .read(searchPopularKeywordProvider.notifier)
                                .initData,
                          )
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
