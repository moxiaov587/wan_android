part of 'models.dart';

@Collection(accessor: 'responseCaches')
class ResponseCache {
  @Index(unique: true)
  late final Id id = Isar.autoIncrement;

  late String uri;

  late DateTime expires;

  late String data;
}
