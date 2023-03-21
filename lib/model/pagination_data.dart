part of 'models.dart';

@Freezed(genericArgumentFactories: true)
class PaginationData<T> with _$PaginationData<T> {
  const factory PaginationData({
    required int curPage,
    required List<T> datas,
    required int offset,
    required int pageCount,
    required int size,
    required int total,
    @Default(false) bool over,
  }) = _PaginationData<T>;

  /// Define a private empty constructor to make custom methods work.
  const PaginationData._();

  factory PaginationData.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PaginationDataFromJson(json, fromJsonT);

  RefreshListViewStateData<T> toRefreshListViewStateData() =>
      RefreshListViewStateData<T>(
        pageNum: curPage,
        isLastPage: over,
        list: datas,
      );
}

class PaginationDataConverter
    implements
        JsonConverter<PaginationData<ArticleModel>, Map<String, dynamic>> {
  const PaginationDataConverter();

  @override
  PaginationData<ArticleModel> fromJson(Map<String, dynamic> json) =>
      PaginationData<ArticleModel>.fromJson(
        json,
        (Object? obj) {
          if (obj is Map<String, dynamic>) {
            return ArticleModel.fromJson(obj);
          }

          return ArticleModel(id: -1, link: '', title: '');
        },
      );

  @override
  Map<String, dynamic> toJson(PaginationData<ArticleModel> model) =>
      <String, dynamic>{
        'curPage': model.curPage,
        'datas': model.datas.map((ArticleModel e) => e.toJson()).toList(),
        'offset': model.offset,
        'over': model.over,
        'pageCount': model.pageCount,
        'size': model.size,
        'total': model.total,
      };
}
