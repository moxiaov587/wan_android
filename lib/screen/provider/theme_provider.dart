part of 'common_provider.dart';

@Riverpod(keepAlive: true, dependencies: <Object>[appDatabase])
class AppThemeMode extends _$AppThemeMode {
  late Isar isar;

  @override
  ThemeMode build() {
    isar = ref.read(appDatabaseProvider);

    return isar.uniqueUserSettings?.themeMode ?? ThemeMode.system;
  }

  void switchThemeMode(ThemeMode themeMode) {
    if (state == themeMode) {
      return;
    }

    state = themeMode;

    final UserSettings userSettings = isar.writeUniqueUserSettings(
      themeMode: themeMode,
    );

    unawaited(
      isar.writeTxn<int>(() async => isar.userSettingsCache.put(userSettings)),
    );
  }
}

extension ThemeModeExtension on ThemeMode {
  Brightness? get brightness {
    switch (this) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return null;
    }
  }
}
