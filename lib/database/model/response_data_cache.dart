part of 'models.dart';

@freezed
@Collection(accessor: 'responseDataCaches')
class ResponseDataCache with _$ResponseDataCache {
  const factory ResponseDataCache({
    @Id() required String uri,
    required DateTime expires,
    required String data,
  }) = _ResponseDataCache;
}
