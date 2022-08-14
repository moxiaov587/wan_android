import 'package:flutter/material.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database_manager.dart';

final StateNotifierProvider<LocaleNotifier, Locale?> localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale?>((_) {
  final Locale? languages = DatabaseManager.uniqueUserSettings?.languages;

  return LocaleNotifier(languages);
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier(super.state);

  static const List<Locale?> locales = <Locale?>[
    null,
    Locale('en'),
    Locale('zh', 'CN'),
  ];

  void switchLocale(Locale? languages) {
    if (!locales.contains(languages)) {
      return;
    }

    state = languages;

    final UserSettings userSettings = DatabaseManager.writeUniqueUserSettings(
      languages: languages,
      enforceWriteLanguages: true,
    );

    DatabaseManager.isar.writeTxnSync<int>(
      () => DatabaseManager.isar.userSettingsCache.putSync(userSettings),
    );
  }
}
