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
    required List<T> list,
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
    @Default(0) int pageNum,
    @Default(false) bool isLastPage,
    required List<T> list,
  }) = RefreshListViewStateData<T>;
  const factory RefreshListViewState.loading() = RefreshListViewStateLoading<T>;
  const factory RefreshListViewState.error({
    int? statusCode,
    String? message,
    String? detail,
  }) = RefreshListViewStateError<T>;
}

class ModelToRefreshListData<T> {
  ModelToRefreshListData({
    required this.curPage,
    required this.datas,
    required this.offset,
    required this.over,
    required this.pageCount,
    required this.size,
    required this.total,
  });

  factory ModelToRefreshListData.fromJson({
    required Map<String, dynamic> json,
    required T Function(Map<String, dynamic> json) formJson,
  }) {
    return ModelToRefreshListData<T>(
      curPage: json['curPage'] as int,
      datas: (json['datas'] as List<dynamic>)
          .map((dynamic e) => formJson(e as Map<String, dynamic>))
          .toList(),
      offset: json['offset'] as int,
      over: json['over'] as bool,
      pageCount: json['pageCount'] as int,
      size: json['size'] as int,
      total: json['total'] as int,
    );
  }

  RefreshListViewStateData<T> toRefreshListViewStateData() {
    return RefreshListViewStateData<T>(
      pageNum: curPage,
      isLastPage: over,
      list: datas,
    );
  }

  /// [curPage] actually the page number of the next page
  final int curPage;
  final List<T> datas;
  final int offset;
  final bool over;
  final int pageCount;
  final int size;
  final int total;
}
