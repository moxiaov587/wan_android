part of 'models.dart';

@freezed
class UserInfoModel with _$UserInfoModel {
  factory UserInfoModel({
    @JsonKey(name: 'coinInfo') required UserPointsModel userPoints,
    @JsonKey(name: 'userInfo') required UserModel user,
  }) = _UserInfoModel;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);
}
