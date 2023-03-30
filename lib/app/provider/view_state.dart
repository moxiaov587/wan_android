import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class ListViewState<T> with _$ListViewState<T> {
  @Deprecated('use AsyncValue<List<T>>.data instead.')
  const factory ListViewState({
    required List<T> list,
  }) = ListViewStateData<T>;
  @Deprecated('use AsyncValue<List<T>>.loading instead.')
  const factory ListViewState.loading() = ListViewStateLoading<T>;
  @Deprecated('use AsyncValue<List<T>>.error instead.')
  const factory ListViewState.error(Object e, StackTrace s) =
      ListViewStateError<T>;
}

@Freezed(makeCollectionsUnmodifiable: false)
class RefreshListViewState<T> with _$RefreshListViewState<T> {
  @Deprecated('use AsyncValue<PaginationData<T>>.data instead.')
  const factory RefreshListViewState({
    required List<T> list,
    @Default(0) int pageNum,
    @Default(false) bool isLastPage,
  }) = RefreshListViewStateData<T>;
  @Deprecated('use AsyncValue<PaginationData<T>>.loading instead.')
  const factory RefreshListViewState.loading() = RefreshListViewStateLoading<T>;
  @Deprecated('use AsyncValue<PaginationData<T>>.error instead.')
  const factory RefreshListViewState.error(Object e, StackTrace s) =
      RefreshListViewStateError<T>;
}
