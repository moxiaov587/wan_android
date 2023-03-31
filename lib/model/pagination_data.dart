part of 'models.dart';

@Freezed(
  makeCollectionsUnmodifiable: false,
  genericArgumentFactories: true,
)
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

  factory PaginationData.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PaginationDataFromJson(json, fromJsonT);
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
