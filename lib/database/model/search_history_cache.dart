part of 'models.dart';

@freezed
@Collection(accessor: 'searchHistoryCaches')
class SearchHistoryCache with _$SearchHistoryCache {
  const factory SearchHistoryCache({
    required int id,
    required String keyword,
    required DateTime updateTime,
  }) = _SearchHistoryCache;
}
