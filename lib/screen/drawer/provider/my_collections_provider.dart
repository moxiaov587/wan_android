part of 'drawer_provider.dart';

const String kMyCollectionsProvider = 'kMyCollectionsProvider';

final AutoDisposeStateNotifierProvider<MyCollectionsNotifier,
        RefreshListViewState<CollectModel>> myCollectionsProvider =
    StateNotifierProvider.autoDispose<MyCollectionsNotifier,
        RefreshListViewState<CollectModel>>(
  (AutoDisposeStateNotifierProviderRef<MyCollectionsNotifier,
          RefreshListViewState<CollectModel>>
      ref) {
    final CancelToken cancelToken = CancelToken();

    ref.onDispose(() {
      cancelToken.cancel();
    });

    return MyCollectionsNotifier(
      const RefreshListViewState<CollectModel>.loading(),
      cancelToken: cancelToken,
    );
  },
  name: kMyCollectionsProvider,
);

class MyCollectionsNotifier extends BaseRefreshListViewNotifier<CollectModel> {
  MyCollectionsNotifier(
    RefreshListViewState<CollectModel> state, {
    this.cancelToken,
  }) : super(
          state,
          initialPageNum: 0,
        );

  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<CollectModel>> loadData(
      {required int pageNum, required int pageSize}) async {
    return (await WanAndroidAPI.fetchCollectArticles(
      pageNum,
      pageSize,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }

  void toggleCollected(
    int id, {
    required bool isCollected,
  }) {
    state.whenOrNull((int pageNum, bool isLastPage, List<CollectModel> list) {
      state = RefreshListViewStateData<CollectModel>(
        pageNum: pageNum,
        isLastPage: isLastPage,
        list: list
            .map((CollectModel collect) => collect.id == id
                ? collect.copyWith(
                    collect: isCollected,
                  )
                : collect)
            .toList(),
      );
    });
  }
}
