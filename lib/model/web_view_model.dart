part of 'models.dart';

@freezed
class WebViewModel with _$WebViewModel {
  factory WebViewModel({
    required int id,
    required String link,
    int? originId,
    String? title,
    required bool collect,
  }) = _WebViewModel;
}
