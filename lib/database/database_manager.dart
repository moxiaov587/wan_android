import 'dart:io';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../screen/provider/locale_provider.dart' show Language;
import 'model/models.dart';

export 'package:isar/isar.dart';
export 'model/models.dart';

class DatabaseManager {
  const DatabaseManager._();

  static late final Isar isar;

  static IsarCollection<AccountCache> get accountCaches => isar.accountCaches;
  static IsarCollection<HomeBannerCache> get homeBannerCaches =>
      isar.homeBannerCaches;
  static IsarCollection<ResponseCache> get responseCaches =>
      isar.responseCaches;
  static IsarCollection<SearchHistory> get searchHistoryCaches =>
      isar.searchHistoryCaches;
  static IsarCollection<UserSettings> get userSettingsCache =>
      isar.userSettingsCache;

  static UserSettings? get uniqueUserSettings =>
      DatabaseManager.userSettingsCache.where().findFirstSync();

  static UserSettings writeUniqueUserSettings({
    bool? rememberPassword,
    ThemeMode? themeMode,
    Language? language,
    bool enforceWriteLanguage = false,
  }) {
    final UserSettings? uniqueUserSettings =
        DatabaseManager.userSettingsCache.where().findFirstSync();

    final UserSettings userSettings = UserSettings();

    if (uniqueUserSettings != null) {
      userSettings
        ..id = uniqueUserSettings.id
        ..rememberPassword =
            rememberPassword ?? uniqueUserSettings.rememberPassword
        ..themeMode = themeMode ?? uniqueUserSettings.themeMode
        ..language = enforceWriteLanguage
            ? language
            : language ?? uniqueUserSettings.language;
    } else {
      if (rememberPassword != null) {
        userSettings.rememberPassword = rememberPassword;
      }

      if (themeMode != null) {
        userSettings.themeMode = themeMode;
      }

      if (language != null || enforceWriteLanguage) {
        userSettings.language = language;
      }
    }

    return userSettings;
  }

  static Future<void> openIsar() async {
    final Directory dir = await getApplicationSupportDirectory();

    isar = await Isar.open(
      <CollectionSchema<dynamic>>[
        AccountCacheSchema,
        HomeBannerCacheSchema,
        ResponseCacheSchema,
        SearchHistorySchema,
        UserSettingsSchema,
      ],
      directory: dir.path,
    );
  }
}
