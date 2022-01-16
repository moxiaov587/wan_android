import 'package:hive/hive.dart';

import 'model/models.dart';

const String boxPrefix = 'app';

class HiveBoxes {
  const HiveBoxes._();

  static late Box<ResponseCache> responseCacheBox;

  static late Box<SearchHistory> searchHistoryBox;

  static late Box<AuthorizedCache> authorizedCacheBox;

  static late Box<UserSettings> userSettingsBox;

  static UserSettings? get uniqueUserSettings =>
      HiveBoxes.userSettingsBox.isNotEmpty
          ? HiveBoxes.userSettingsBox.values.first
          : null;

  static Future<void> openBoxes() async {
    Hive.registerAdapter(ResponseCacheAdapter());
    Hive.registerAdapter(SearchHistoryAdapter());
    Hive.registerAdapter(AuthorizedCacheAdapter());
    Hive.registerAdapter(UserSettingsAdapter());

    await Future.wait(
      <Future<void>>[
        () async {
          responseCacheBox = await Hive.openBox('${boxPrefix}_response_cache');
        }(),
        () async {
          searchHistoryBox = await Hive.openBox('${boxPrefix}_search_history');
        }(),
        () async {
          authorizedCacheBox =
              await Hive.openBox('${boxPrefix}_authorized_cache');
        }(),
        () async {
          userSettingsBox = await Hive.openBox('${boxPrefix}_user_settings');
        }(),
      ],
    );
  }

  static Future<void> clearCache() {
    return Future.wait<void>(<Future<dynamic>>[
      responseCacheBox.clear(),
      searchHistoryBox.clear(),
    ]);
  }
}

class HiveAdapterTypeIds {
  const HiveAdapterTypeIds._();

  static const int responseCache = 0;

  static const int searchHistory = 1;

  static const int authorizedCache = 2;

  static const int userSettings = 3;
}
