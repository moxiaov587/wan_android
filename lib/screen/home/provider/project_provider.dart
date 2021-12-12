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

  @override
  Future<List<ProjectTypeModel>> loadData() {
    return WanAndroidAPI.fetchProjectTypes();
  }
}
