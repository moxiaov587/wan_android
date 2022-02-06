part of 'models.dart';

class ArticleModelToRefreshListDataConverter
    implements
        JsonConverter<ModelToRefreshListData<ArticleModel>,
            Map<String, dynamic>> {
  const ArticleModelToRefreshListDataConverter();

  @override
  ModelToRefreshListData<ArticleModel> fromJson(Map<String, dynamic> json) =>
      ModelToRefreshListData<ArticleModel>.fromJson(
        json: json,
        formJson: ArticleModel.fromJson,
      );

  @override
  Map<String, dynamic> toJson(ModelToRefreshListData<ArticleModel> model) =>
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

@freezed
class TheyShareModel with _$TheyShareModel {
  factory TheyShareModel({
    @JsonKey(name: 'coinInfo') required UserPointsModel userPoints,
    @ArticleModelToRefreshListDataConverter()
        required ModelToRefreshListData<ArticleModel> shareArticles,
  }) = _TheyShareModel;

  factory TheyShareModel.fromJson(Map<String, dynamic> json) =>
      _$TheyShareModelFromJson(json);
}
