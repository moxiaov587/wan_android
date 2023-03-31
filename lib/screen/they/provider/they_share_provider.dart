part of 'they_provider.dart';

@riverpod
class TheyShare extends _$TheyShare with LoadMoreMixin<ArticleModel> {
  late Http http;

  UserPointsModel? _userPoints;
  UserPointsModel? get userPoints => _userPoints;

  @override
  Future<PaginationData<ArticleModel>> build(
    int userId, {
    int? pageNum,
    int? pageSize,
  }) async {
    final CancelToken cancelToken = ref.cancelToken();

    http = ref.watch(networkProvider);

    final TheyShareModel data = await http.fetchShareArticlesByUserId(
      pageNum ?? initialPageNum,
      pageSize ?? initialPageSize,
      userId: userId,
      cancelToken: cancelToken,
    );

    _userPoints = data.userPoints;

    return data.shareArticles;
  }

  @override
  Future<PaginationData<ArticleModel>> Function(int pageNum, int pageSize)
      get buildMore => (int pageNum, int pageSize) => build(
            userId,
            pageNum: pageNum,
            pageSize: pageSize,
          );
}
