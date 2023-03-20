part of 'home_provider.dart';

@riverpod
Future<List<ProjectTypeModel>> projectType(ProjectTypeRef ref) {
  return ref.watch(networkProvider).fetchProjectTypes();
}

@riverpod
class CurrentProjectType extends _$CurrentProjectType
    with AutoDisposeNotifierUpdateMixin<AsyncValue<ProjectTypeModel>> {
  @override
  AsyncValue<ProjectTypeModel> build() {
    return ref.watch(projectTypeProvider).when(
          skipLoadingOnRefresh: false,
          data: (List<ProjectTypeModel> data) =>
              AsyncValue<ProjectTypeModel>.data(data.first),
          error: (Object e, StackTrace s) =>
              AsyncValue<ProjectTypeModel>.error(e, s),
          loading: () => const AsyncValue<ProjectTypeModel>.loading(),
        );
  }
}

typedef ProjectArticleProvider = AutoDisposeStateNotifierProvider<
    ProjectNotifier, RefreshListViewState<ArticleModel>>;

final ProjectArticleProvider projectArticleProvider = StateNotifierProvider
    .autoDispose<ProjectNotifier, RefreshListViewState<ArticleModel>>(
  (AutoDisposeStateNotifierProviderRef<ProjectNotifier,
          RefreshListViewState<ArticleModel>>
      ref) {
    final CancelToken cancelToken = ref.cancelToken();

    final Http http = ref.read(networkProvider);

    return ref.watch(currentProjectTypeProvider).when(
          data: (ProjectTypeModel value) => ProjectNotifier(
            const RefreshListViewState<ArticleModel>.loading(),
            categoryId: value.id,
            http: http,
            cancelToken: cancelToken,
          )..initData(),
          loading: () => ProjectNotifier(
            const RefreshListViewState<ArticleModel>.loading(),
            categoryId: null,
            http: http,
            cancelToken: cancelToken,
          ),
          error: (Object e, StackTrace s) => ProjectNotifier(
            RefreshListViewState<ArticleModel>.error(e, s),
            categoryId: null,
            http: http,
            cancelToken: cancelToken,
          ),
        );
  },
  name: kProjectArticleProvider,
);

class ProjectNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  ProjectNotifier(
    super.state, {
    required this.categoryId,
    required this.http,
    this.cancelToken,
  }) : super(initialPageNum: 1);

  final int? categoryId;
  final Http http;
  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await http.fetchProjectArticles(
      pageNum,
      pageSize,
      categoryId: categoryId!,
      cancelToken: cancelToken,
    ))
        .toRefreshListViewStateData();
  }
}
