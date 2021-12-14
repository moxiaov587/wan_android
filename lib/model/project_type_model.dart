part of 'models.dart';

@freezed
class ProjectTypeModel with _$ProjectTypeModel {
  factory ProjectTypeModel({
    @Default(<ProjectTypeModel>[]) List<ProjectTypeModel> children,
    @Default(0) int courseId,
    @Default(0) int id,
    @Default('') String name,
    @Default(0) int order,
    @Default(0) int parentChapterId,
    @Default(0) int visible,
    @JsonKey(ignore: true) @Default(false) bool isSelected,
  }) = _ProjectTypeModel;

  factory ProjectTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectTypeModelFromJson(json);
}
