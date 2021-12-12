import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_state.freezed.dart';

@freezed
class ViewState<T> with _$ViewState<T> {
  const factory ViewState({
    T? value,
  }) = ViewStateData<T>;
  const factory ViewState.loading() = ViewStateLoading<T>;
  const factory ViewState.error({
    int? statusCode,
    String? message,
    String? detail,
  }) = ViewStateError<T>;
}

@freezed
class ListViewState<T> with _$ListViewState<T> {
  const factory ListViewState({
    required List<T> value,
  }) = ListViewStateData<T>;
  const factory ListViewState.loading() = ListViewStateLoading<T>;
  const factory ListViewState.error({
    int? statusCode,
    String? message,
    String? detail,
  }) = ListViewStateError<T>;
}

@freezed
class RefreshListViewState<T> with _$RefreshListViewState<T> {
  const factory RefreshListViewState({
    @Default(0) int nextPageNum,
    @Default(false) bool isLastPage,
    required List<T> value,
  }) = RefreshListViewStateData<T>;
  const factory RefreshListViewState.loading() = RefreshListViewStateLoading<T>;
  const factory RefreshListViewState.error({
    int? statusCode,
    String? message,
    String? detail,
  }) = RefreshListViewStateError<T>;
}
