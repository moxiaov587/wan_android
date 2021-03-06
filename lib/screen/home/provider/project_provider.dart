part of 'home_provider.dart';

final StateNotifierProvider<ProjectTypeNotifier,
        ListViewState<ProjectTypeModel>> projectTypesProvider =
    StateNotifierProvider<ProjectTypeNotifier, ListViewState<ProjectTypeModel>>(
  (_) {
    return ProjectTypeNotifier(
      const ListViewState<ProjectTypeModel>.loading(),
    );
  },
);

class ProjectTypeNotifier extends BaseListViewNotifier<ProjectTypeModel> {
  ProjectTypeNotifier(super.state);

  @override
  Future<List<ProjectTypeModel>> loadData() {
    return WanAndroidAPI.fetchProjectTypes();
  }
}

final StateNotifierProvider<CurrentProjectTypeNotifier,
        ViewState<ProjectTypeModel>> currentProjectTypeProvider =
    StateNotifierProvider<CurrentProjectTypeNotifier,
        ViewState<ProjectTypeModel>>(
  (StateNotifierProviderRef<CurrentProjectTypeNotifier,
          ViewState<ProjectTypeModel>>
      ref) {
    return CurrentProjectTypeNotifier(
      ref.watch(projectTypesProvider).when(
            (List<ProjectTypeModel> value) =>
                ViewState<ProjectTypeModel>(value: value.first),
            loading: () => const ViewStateLoading<ProjectTypeModel>(),
            error: (int? statusCode, String? message, String? detail) =>
                ViewStateError<ProjectTypeModel>(
              statusCode: statusCode,
              message: message,
              detail: detail,
            ),
          ),
    );
  },
);

class CurrentProjectTypeNotifier
    extends StateNotifier<ViewState<ProjectTypeModel>> {
  CurrentProjectTypeNotifier(super.state);

  void selected(ProjectTypeModel data) {
    state = ViewState<ProjectTypeModel>(value: data);
  }
}

final StateNotifierProvider<ProjectNotifier, RefreshListViewState<ArticleModel>>
    projectArticleProvider =
    StateNotifierProvider<ProjectNotifier, RefreshListViewState<ArticleModel>>(
  (StateNotifierProviderRef<ProjectNotifier, RefreshListViewState<ArticleModel>>
      ref) {
    return ref.watch(currentProjectTypeProvider).when(
          (ProjectTypeModel? value) => ProjectNotifier(
            const RefreshListViewState<ArticleModel>.loading(),
            categoryId: value!.id,
          )..initData(),
          loading: () => ProjectNotifier(
            const RefreshListViewState<ArticleModel>.loading(),
            categoryId: null,
          ),
          error: (int? statusCode, String? message, String? detail) =>
              ProjectNotifier(
            RefreshListViewState<ArticleModel>.error(
              statusCode: statusCode,
              message: message,
              detail: detail,
            ),
            categoryId: null,
          ),
        );
  },
  name: kProjectArticleProvider,
);

class ProjectNotifier extends BaseRefreshListViewNotifier<ArticleModel>
    with ArticleNotifierSwitchCollectMixin {
  ProjectNotifier(
    super.state, {
    required this.categoryId,
  }) : super(initialPageNum: 0);

  final int? categoryId;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData({
    required int pageNum,
    required int pageSize,
  }) async {
    return (await WanAndroidAPI.fetchProjectArticles(
      pageNum,
      pageSize,
      categoryId: categoryId!,
    ))
        .toRefreshListViewStateData();
  }
}
