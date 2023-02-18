part of 'they_provider.dart';

final AutoDisposeStateNotifierProviderFamily<TheyShareNotifier,
        RefreshListViewState<ArticleModel>, int> theyShareProvider =
    StateNotifierProvider.family.autoDispose<TheyShareNotifier,
        RefreshListViewState<ArticleModel>, int>((
  AutoDisposeStateNotifierProviderRef<TheyShareNotifier,
          RefreshListViewState<ArticleModel>>
      ref,
  int userId,
) {
  final CancelToken cancelToken = ref.cancelToken();

  final Http http = ref.watch(networkProvider);

  return TheyShareNotifier(
    const RefreshListViewState<ArticleModel>.loading(),
    userId: userId,
    http: http,
    cancelToken: cancelToken,
  )..initData();
});

class TheyShareNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  TheyShareNotifier(
    super.state, {
    required this.userId,
    required this.http,
    this.cancelToken,
  });

  final int userId;
  final Http http;
  final CancelToken? cancelToken;

  UserPointsModel? _userPoints;
  UserPointsModel? get userPoints => _userPoints;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    final TheyShareModel userShareArticleModel =
        await http.fetchShareArticlesByUserId(
      pageNum,
      pageSize,
      userId: userId,
      cancelToken: cancelToken,
    );

    _userPoints = userShareArticleModel.userPoints;

    return userShareArticleModel.shareArticles.toRefreshListViewStateData();
  }
}
