part of 'models.dart';

@freezed
class WebViewModel with _$WebViewModel {
  factory WebViewModel({
    required int id,
    required String link,
    required bool collect,
    int? originId,
    String? title,
    @JsonKey(includeFromJson: true) @Default(false) bool withCookie,
  }) = _WebViewModel;
}
