part of 'models.dart';

@freezed
class PointsModel with _$PointsModel {
  factory PointsModel({
    required int coinCount,
    required int id,
    int? date,
    String? desc,
    String? reason,
    int? type,
    int? userId,
    String? userName,
  }) = _PointsModel;

  factory PointsModel.fromJson(Map<String, dynamic> json) =>
      _$PointsModelFromJson(json);
}
