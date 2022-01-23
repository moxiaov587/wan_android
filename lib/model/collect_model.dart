part of 'models.dart';

@freezed
class CollectModel with _$CollectModel {
  factory CollectModel({
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
  }) = _CollectModel;

  factory CollectModel.fromJson(Map<String, dynamic> json) =>
      _$CollectModelFromJson(json);
}
