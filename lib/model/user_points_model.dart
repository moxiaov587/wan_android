part of 'models.dart';

@freezed
class UserPointsModel with _$UserPointsModel {
  factory UserPointsModel({
    @Default(0) int coinCount,
    @Default(1) int level,
    String? nickname,
    String? rank,
    required int userId,
    String? username,
  }) = _UserPointsModel;

  factory UserPointsModel.fromJson(Map<String, dynamic> json) =>
      _$UserPointsModelFromJson(json);
}
