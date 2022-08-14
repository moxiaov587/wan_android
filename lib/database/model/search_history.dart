part of 'models.dart';

@Collection(accessor: 'searchHistoryCaches')
class SearchHistory {
  @Index(unique: true)
  late Id id = Isar.autoIncrement;

  late String keyword;

  late DateTime updateTime;
}
