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
  ProjectTypeNotifier(ListViewState<ProjectTypeModel> state) : super(state);

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  @override
  Future<List<ProjectTypeModel>> loadData() async {
    final List<ProjectTypeModel> data = await WanAndroidAPI.fetchProjectTypes();
    data.first = data.first.copyWith(isSelected: true);

    return data;
  }

  void selected(int index) {
    state.whenOrNull(
      (List<ProjectTypeModel> value) {
        if (_selectedIndex != index) {
          value[_selectedIndex] =
              value[_selectedIndex].copyWith(isSelected: false);

          value[index] = value[index].copyWith(isSelected: true);

          _selectedIndex = index;

          state = ListViewState<ProjectTypeModel>(list: value);
        }
      },
    );
  }
}

final StateProvider<ViewState<ProjectTypeModel>> currentProjectTypeProvider =
    StateProvider<ViewState<ProjectTypeModel>>(
  (StateProviderRef<ViewState<ProjectTypeModel>> ref) {
    return ref.watch(projectTypesProvider).when(
          (List<ProjectTypeModel> value) => ViewStateData<ProjectTypeModel>(
            value: value[ref.read(projectTypesProvider.notifier).selectedIndex],
          ),
          loading: () => const ViewStateLoading<ProjectTypeModel>(),
          error: (int? statusCode, String? message, String? detail) =>
              ViewStateError<ProjectTypeModel>(
            statusCode: statusCode,
            message: message,
            detail: detail,
          ),
        );
  },
);

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

class ProjectNotifier extends BaseArticleNotifier {
  ProjectNotifier(
    RefreshListViewState<ArticleModel> state, {
    required this.categoryId,
  }) : super(state);

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
