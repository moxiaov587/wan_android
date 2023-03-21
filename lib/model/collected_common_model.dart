part of 'models.dart';

@freezed
class CollectedCommonModel with _$CollectedCommonModel {
  factory CollectedCommonModel({
    required int id,
    required String title,
    required String link,
    String? author,
  }) = _CollectedCommonModel;

  factory CollectedCommonModel.fromJson(Map<String, dynamic> json) =>
      _$CollectedCommonModelFromJson(json);
}
