part of 'home_provider.dart';

@riverpod
Future<List<ProjectTypeModel>> projectType(ProjectTypeRef ref) =>
    ref.watch(networkProvider).fetchProjectTypes();

@riverpod
class CurrentProjectType extends _$CurrentProjectType {
  @override
  Future<ProjectTypeModel> build() async {
    final List<ProjectTypeModel> types = await ref.watch(
      projectTypeProvider.selectAsync((List<ProjectTypeModel> data) => data),
    );

    return types.first;
  }

  Future<void> onSelect(ProjectTypeModel type) => update((_) => type);
}

@riverpod
class ProjectArticle extends _$ProjectArticle with LoadMoreMixin<ArticleModel> {
  late Http _http;

  @override
  Future<PaginationData<ArticleModel>> build({
    int pageNum = kDefaultPageNum,
    int pageSize = kDefaultPageSize,
  }) async {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);

    final ProjectTypeModel type = await ref.watch(
      currentProjectTypeProvider.selectAsync((ProjectTypeModel data) => data),
    );

    return _http.fetchProjectArticles(
      pageNum,
      pageSize,
      categoryId: type.id,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<ArticleModel>> buildMore(int pageNum, int pageSize) =>
      build(pageNum: pageNum, pageSize: pageSize);
}
