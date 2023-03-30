part of 'home_provider.dart';

@Riverpod(keepAlive: true)
Future<List<ProjectTypeModel>> projectType(ProjectTypeRef ref) =>
    ref.watch(networkProvider).fetchProjectTypes();

@riverpod
class CurrentProjectType extends _$CurrentProjectType {
  @override
  Future<ProjectTypeModel> build() async {
    final List<ProjectTypeModel> types =
        ref.read(projectTypeProvider).valueOrNull ??
            await ref.watch(projectTypeProvider.future);

    return types.first;
  }

  Future<void> onSelect(ProjectTypeModel type) => update((_) => type);
}

@riverpod
class ProjectArticle extends _$ProjectArticle with LoadMoreMixin<ArticleModel> {
  late Http http;

  @override
  Future<PaginationData<ArticleModel>> build({
    int? pageNum,
    int? pageSize,
  }) async {
    final CancelToken cancelToken = ref.cancelToken();

    http = ref.watch(networkProvider);

    final ProjectTypeModel type =
        ref.read(currentProjectTypeProvider).valueOrNull ??
            await ref.watch(currentProjectTypeProvider.future);

    return http.fetchProjectArticles(
      pageNum ?? initialPageNum,
      pageSize ?? initialPageSize,
      categoryId: type.id,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<PaginationData<ArticleModel>> Function(int pageNum, int pageSize)
      get buildMore => (int pageNum, int pageSize) => build(
            pageNum: pageNum,
            pageSize: pageSize,
          );
}
