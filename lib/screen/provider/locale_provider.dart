import 'package:flutter/material.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database_manager.dart';

final StateNotifierProvider<LocaleNotifier, Language?> localeProvider =
    StateNotifierProvider<LocaleNotifier, Language?>((_) {
  final Language? language = DatabaseManager.uniqueUserSettings?.language;

  return LocaleNotifier(language);
});

enum Language {
  en,
  zh;

  Locale get value {
    switch (this) {
      case Language.en:
        return const Locale('en');
      case Language.zh:
        return const Locale('zh');
    }
  }
}

class LocaleNotifier extends StateNotifier<Language?> {
  LocaleNotifier(super.state);

  static const List<Language?> languages = <Language?>[
    null,
    ...Language.values,
  ];

  void switchLocale(Language? language) {
    if (!languages.contains(language)) {
      return;
    }

    state = language;

    final UserSettings userSettings = DatabaseManager.writeUniqueUserSettings(
      language: language,
      enforceWriteLanguage: true,
    );

    DatabaseManager.isar.writeTxnSync<int>(
      () => DatabaseManager.isar.userSettingsCache.putSync(userSettings),
    );
  }
}
