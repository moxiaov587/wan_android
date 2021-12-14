part of 'home_provider.dart';

final StateNotifierProvider<ProjectTypeNotifier,
        ListViewState<ProjectTypeModel>> projectTypesProvider =
    StateNotifierProvider<ProjectTypeNotifier, ListViewState<ProjectTypeModel>>(
        (_) {
  return ProjectTypeNotifier(
    const ListViewState<ProjectTypeModel>.loading(),
  );
});

class ProjectTypeNotifier extends BaseListViewNotifier<ProjectTypeModel> {
  ProjectTypeNotifier(
    ListViewState<ProjectTypeModel> state, {
    this.cancelToken,
  }) : super(state);

  final CancelToken? cancelToken;

  late int _selectedId;

  @override
  Future<List<ProjectTypeModel>> loadData() async {
    final List<ProjectTypeModel> data = await WanAndroidAPI.fetchProjectTypes();
    data.first = data.first.copyWith(isSelected: true);
    _selectedId = data.first.id;
    return data;
  }

  void selected(int index) {
    state.whenOrNull(
      (List<ProjectTypeModel> value) {
        if (_selectedId != value[index].id) {
          final int lastSelectedIndex = value.indexWhere(
              (ProjectTypeModel element) => element.id == _selectedId);

          value[lastSelectedIndex] =
              value[lastSelectedIndex].copyWith(isSelected: false);

          value[index] = value[index].copyWith(isSelected: true);

          _selectedId = value[index].id;

          state = ListViewState<ProjectTypeModel>(list: value);
        }
      },
    );
  }
}

final StateProviderFamily<bool, int> projectTypeIsSelectedProvider =
    StateProvider.family<bool, int>((StateProviderRef<bool> ref, int index) {
  final bool isSelected = ref.watch(
    projectTypesProvider.select(
      (ListViewState<ProjectTypeModel> value) =>
          value.whenOrNull(
              (List<ProjectTypeModel> value) => value[index].isSelected) ??
          false,
    ),
  );
  return isSelected;
});

final StateProvider<ViewState<ProjectTypeModel>> currentProjectTypeProvider =
    StateProvider<ViewState<ProjectTypeModel>>(
        (StateProviderRef<ViewState<ProjectTypeModel>> ref) {
  return ref.watch(projectTypesProvider).when(
        (List<ProjectTypeModel> value) => ViewStateData<ProjectTypeModel>(
          value: value.firstWhereOrNull(
                  (ProjectTypeModel element) => element.isSelected) ??
              value.first,
        ),
        loading: () => const ViewStateLoading<ProjectTypeModel>(),
        error: (_, __, ___) => const ViewStateError<ProjectTypeModel>(),
      );
});

final StateNotifierProvider<ProjectNotifier, RefreshListViewState<ArticleModel>>
    projectArticleProvider =
    StateNotifierProvider<ProjectNotifier, RefreshListViewState<ArticleModel>>(
        (StateNotifierProviderRef<ProjectNotifier,
                RefreshListViewState<ArticleModel>>
            ref) {
  final int? categoryId = ref
      .watch(currentProjectTypeProvider)
      .whenOrNull<int?>((ProjectTypeModel? value) => value!.id);

  if (categoryId != null) {
    return ProjectNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
      categoryId: categoryId,
    )..initData();
  } else {
    return ProjectNotifier(
      const RefreshListViewState<ArticleModel>.loading(),
      categoryId: categoryId,
    );
  }
});

class ProjectNotifier extends BaseRefreshListViewNotifier<ArticleModel> {
  ProjectNotifier(
    RefreshListViewState<ArticleModel> state, {
    required this.categoryId,
    this.cancelToken,
  }) : super(state);

  final int? categoryId;
  final CancelToken? cancelToken;

  @override
  Future<RefreshListViewStateData<ArticleModel>> loadData(
      {required int pageNum, required int pageSize}) async {
    final RefreshArticleListModel data =
        await WanAndroidAPI.fetchProjectArticles(pageNum, pageSize,
            categoryId: categoryId!);

    return RefreshListViewStateData<ArticleModel>(
      nextPageNum: data.curPage,
      isLastPage: data.over,
      list: data.datas,
    );
  }
}
