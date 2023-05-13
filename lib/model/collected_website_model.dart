part of 'models.dart';

@freezed
class CollectedWebsiteModel with _$CollectedWebsiteModel {
  factory CollectedWebsiteModel({
    required int id,
    required String link,
    String? desc,
    String? icon,
    String? name,
    int? order,
    int? userId,
    int? visible,
    @JsonKey(includeFromJson: true) @Default(true) bool collect,
  }) = _CollectedWebsiteModel;

  factory CollectedWebsiteModel.fromJson(Map<String, dynamic> json) =>
      _$CollectedWebsiteModelFromJson(json);
}
