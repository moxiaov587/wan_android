import 'package:hive/hive.dart';

import 'model/models.dart';

const String boxPrefix = 'app';

class HiveBoxes {
  const HiveBoxes._();

  static late Box<ResponseCache> responseCacheBox;

  static late Box<SearchHistory> searchHistoryBox;

  static Future<void> openBoxes() async {
    Hive.registerAdapter(ResponseCacheAdapter());
    Hive.registerAdapter(SearchHistoryAdapter());

    await Future.wait(
      <Future<void>>[
        () async {
          responseCacheBox = await Hive.openBox('${boxPrefix}_response_cache');
        }(),
        () async {
          searchHistoryBox = await Hive.openBox('${boxPrefix}_search_history');
        }(),
      ],
    );
  }
}

class HiveAdapterTypeIds {
  const HiveAdapterTypeIds._();

  static const int responseCache = 0;

  static const int searchHistory = 1;
}
