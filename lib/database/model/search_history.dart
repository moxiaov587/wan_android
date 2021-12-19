part of 'models.dart';

@HiveType(typeId: HiveAdapterTypeIds.searchHistory)
class SearchHistory extends HiveObject {
  SearchHistory({
    required this.keyword,
  });

  @HiveField(0)
  String keyword;
}
