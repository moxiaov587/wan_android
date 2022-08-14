import 'package:flutter/material.dart' show Brightness, ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database_manager.dart';

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

final StateNotifierProvider<ThemeModeNotifier, ThemeMode> themeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((_) {
  final ThemeMode? themeMode = DatabaseManager.uniqueUserSettings?.themeMode;

  return ThemeModeNotifier(themeMode ?? ThemeMode.system);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(super.state);

  void switchThemeMode(ThemeMode themeMode) {
    if (state == themeMode) {
      return;
    }

    state = themeMode;

    final UserSettings userSettings = DatabaseManager.writeUniqueUserSettings(
      themeMode: themeMode,
    );

    DatabaseManager.isar.writeTxnSync<int>(
      () => DatabaseManager.isar.userSettingsCache.putSync(userSettings),
    );
  }
}
