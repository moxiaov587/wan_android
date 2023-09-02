part of 'models.dart';

@freezed
@Collection(accessor: 'accountCaches')
class AccountCache with _$AccountCache {
  const factory AccountCache({
    required int id,
    required String username,
    required DateTime updateTime,
    String? password,
  }) = _AccountCache;
}
