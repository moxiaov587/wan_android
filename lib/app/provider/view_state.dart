import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class ListViewState<T> with _$ListViewState<T> {
  const factory ListViewState({
    required List<T> list,
  }) = ListViewStateData<T>;
  const factory ListViewState.loading() = ListViewStateLoading<T>;
  const factory ListViewState.error(Object e, StackTrace s) =
      ListViewStateError<T>;
}

@Freezed(makeCollectionsUnmodifiable: false)
class RefreshListViewState<T> with _$RefreshListViewState<T> {
  const factory RefreshListViewState({
    required List<T> list,
    @Default(0) int pageNum,
    @Default(false) bool isLastPage,
  }) = RefreshListViewStateData<T>;
  const factory RefreshListViewState.loading() = RefreshListViewStateLoading<T>;
  const factory RefreshListViewState.error(Object e, StackTrace s) =
      RefreshListViewStateError<T>;
}
