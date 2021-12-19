part of 'models.dart';

@freezed
class SearchKeywordModel with _$SearchKeywordModel {
  factory SearchKeywordModel({
    @Default(0) int id,
    @Default('') String link,
    @Default('') String name,
    @Default(0) int order,
    @Default(0) int visible,
  }) = _SearchKeywordModel;

  factory SearchKeywordModel.fromJson(Map<String, dynamic> json) =>
      _$SearchKeywordModelFromJson(json);
}
