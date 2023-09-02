part of 'models.dart';

@freezed
@Collection(accessor: 'bannerCaches')
class BannerCache with _$BannerCache {
  const factory BannerCache({
    required int id,
    String? desc,
    String? imagePath,
    @Default(0) int isVisible,
    @Default(0) int order,
    String? title,
    @Default(0) int type,
    String? url,
    @JsonKey(includeFromJson: false) int? primaryColorValue,
    @JsonKey(includeFromJson: false) int? textColorValue,
  }) = _BannerCache;

  factory BannerCache.fromJson(Map<String, dynamic> json) =>
      _$BannerCacheFromJson(json);
}
