part of 'models.dart';

@freezed
class PointsModel with _$PointsModel {
  factory PointsModel({
    required int coinCount,
    int? date,
    String? desc,
    required int id,
    String? reason,
    int? type,
    int? userId,
    String? userName,
  }) = _PointsModel;

  factory PointsModel.fromJson(Map<String, dynamic> json) =>
      _$PointsModelFromJson(json);
}
