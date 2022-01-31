part of 'models.dart';

@freezed
class CollectedCommonModel with _$CollectedCommonModel {
  factory CollectedCommonModel({
    required int id,
    String? author,
    required String title,
    required String link,
  }) = _CollectedCommonModel;

  factory CollectedCommonModel.fromJson(Map<String, dynamic> json) =>
      _$CollectedCommonModelFromJson(json);
}
