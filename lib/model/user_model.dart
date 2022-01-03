part of 'models.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    @Default(false) bool admin,
    @Default(<dynamic>[]) List<dynamic> chapterTops,
    @Default(0) int coinCount,
    @Default(<dynamic>[]) List<dynamic> collectIds,
    @Default('') String email,
    @Default('') String icon,
    @Default(0) int id,
    @Default('') String nickname,
    @Default('') String password,
    @Default('') String publicName,
    @Default('') String token,
    @Default(0) int type,
    @Default('') String username,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
