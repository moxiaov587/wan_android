import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_state.freezed.dart';

@freezed
class ListViewState<T> with _$ListViewState<T> {
  const factory ListViewState({
    required List<T> list,
  }) = ListViewStateData<T>;
  const factory ListViewState.loading() = ListViewStateLoading<T>;
  const factory ListViewState.error(Object e, StackTrace s) =
      ListViewStateError<T>;
}

@freezed
class RefreshListViewState<T> with _$RefreshListViewState<T> {
  const factory RefreshListViewState({
    @Default(0) int pageNum,
    @Default(false) bool isLastPage,
    required List<T> list,
  }) = RefreshListViewStateData<T>;
  const factory RefreshListViewState.loading() = RefreshListViewStateLoading<T>;
  const factory RefreshListViewState.error(Object e, StackTrace s) =
      RefreshListViewStateError<T>;
}
