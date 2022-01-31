part of 'models.dart';

@freezed
class CollectedWebsiteModel with _$CollectedWebsiteModel {
  factory CollectedWebsiteModel({
    String? desc,
    String? icon,
    required int id,
    required String link,
    String? name,
    int? order,
    int? userId,
    int? visible,
    @JsonKey(ignore: true) @Default(true) bool collect,
  }) = _CollectedWebsiteModel;

  factory CollectedWebsiteModel.fromJson(Map<String, dynamic> json) =>
      _$CollectedWebsiteModelFromJson(json);
}
