part of 'models.dart';

@freezed
class TheyShareModel with _$TheyShareModel {
  factory TheyShareModel({
    @JsonKey(name: 'coinInfo') required UserPointsModel userPoints,
    @PaginationDataConverter()
        required PaginationData<ArticleModel> shareArticles,
  }) = _TheyShareModel;

  factory TheyShareModel.fromJson(Map<String, dynamic> json) =>
      _$TheyShareModelFromJson(json);
}
