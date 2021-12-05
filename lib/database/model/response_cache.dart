part of 'models.dart';

@HiveType(typeId: HiveAdapterTypeIds.responseCache)
class ResponseCache extends HiveObject {
  ResponseCache({
    required this.uri,
    required this.timeStamp,
    required this.data,
  });

  @HiveField(0)
  String uri;
  @HiveField(1)
  int timeStamp;
  @HiveField(2)
  dynamic data;
}
