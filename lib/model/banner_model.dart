part of 'models.dart';

@freezed
class BannerModel with _$BannerModel {
  factory BannerModel({
    @Default('') String desc,
    @Default(0) int id,
    @Default('') String imagePath,
    @Default(0) int isVisible,
    @Default(0) int order,
    @Default('') String title,
    @Default(0) int type,
    @Default('') String url,
  }) = _BannerModel;

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
}
