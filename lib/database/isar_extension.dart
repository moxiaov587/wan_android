part of 'app_database.dart';

extension IsarExtension on Isar {
  UserSettings? get uniqueUserSettings =>
      userSettingsCache.where().findFirstSync();

  UserSettings writeUniqueUserSettings({
    bool? rememberPassword,
    ThemeMode? themeMode,
    Language? language,
    bool enforceWriteLanguage = false,
  }) {
    final UserSettings? uniqueUserSettings =
        userSettingsCache.where().findFirstSync();

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
}
