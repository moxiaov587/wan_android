part of 'models.dart';

@freezed
class CollectedArticleModel with _$CollectedArticleModel {
  factory CollectedArticleModel({
    String? author,
    int? chapterId,
    String? chapterName,
    int? courseId,
    String? desc,
    String? envelopePic,
    required int id,
    required String link,
    String? niceDate,
    String? origin,
    int? originId,
    int? publishTime,
    String? title,
    int? userId,
    int? visible,
    @Default(0) int zan,
    @JsonKey(ignore: true) @Default(true) bool collect,
  }) = _CollectedArticleModel;

  factory CollectedArticleModel.fromJson(Map<String, dynamic> json) =>
      _$CollectedArticleModelFromJson(json);
}
