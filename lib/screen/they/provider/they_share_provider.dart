part of 'they_provider.dart';

final AutoDisposeStateNotifierProviderFamily<TheyShareNotifier,
        RefreshListViewState<ArticleModel>, int> theyShareProvider =
    StateNotifierProvider.family.autoDispose<
        TheyShareNotifier,
        RefreshListViewState<ArticleModel>,
        int>((AutoDisposeStateNotifierProviderRef<TheyShareNotifier,
                RefreshListViewState<ArticleModel>>
            ref,
        int userId) {
  final CancelToken cancelToken = CancelToken();

  ref.onDispose(() {
    cancelToken.cancel();
  });

  return TheyShareNotifier(
    const RefreshListViewState<ArticleModel>.loading(),
    userId: userId,
    cancelToken: cancelToken,
  );
});

class TheyShareNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  TheyShareNotifier(
    RefreshListViewState<ArticleModel> state, {
    required this.userId,
    this.cancelToken,
  }) : super(state);

  final int userId;
  final CancelToken? cancelToken;

  UserPointsModel? _userPoints;
  UserPointsModel? get userPoints => _userPoints;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData(
      {required int pageNum, required int pageSize}) async {
    final TheyShareModel userShareArticleModel =
        await WanAndroidAPI.fetchShareArticlesByUserId(
      pageNum,
      pageSize,
      userId: userId,
      cancelToken: cancelToken,
    );

    _userPoints = userShareArticleModel.userPoints;

    return userShareArticleModel.shareArticles.toRefreshListViewStateData();
  }
}
