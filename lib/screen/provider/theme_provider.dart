part of 'common_provider.dart';

@Riverpod(dependencies: <Object>[appDatabase])
class AppThemeMode extends _$AppThemeMode {
  late Isar _isar;

  @override
  ThemeMode build() {
    _isar = ref.read(appDatabaseProvider);

    return _isar.uniqueUserSettings?.themeMode ?? ThemeMode.system;
  }

  void switchThemeMode(ThemeMode themeMode) {
    if (state == themeMode) {
      return;
    }

    state = themeMode;

    final UserSettings userSettings = _isar.writeUniqueUserSettings(
      themeMode: themeMode,
    );

    unawaited(
      _isar
          .writeTxn<int>(() async => _isar.userSettingsCache.put(userSettings)),
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
