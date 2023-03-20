part of 'common_provider.dart';

@Riverpod(keepAlive: true)
class AppLanguage extends _$AppLanguage {
  late Isar isar;

  static const List<Language?> languages = <Language?>[
    null,
    ...Language.values,
  ];

  @override
  Language? build() {
    isar = ref.read(appDatabaseProvider);

    return isar.uniqueUserSettings?.language;
  }

  void switchLocale(Language? language) {
    if (!languages.contains(language)) {
      return;
    }

    state = language;

    final UserSettings userSettings =
        ref.read(appDatabaseProvider).writeUniqueUserSettings(
              language: language,
              enforceWriteLanguage: true,
            );

    isar.writeTxnSync<int>(() => isar.userSettingsCache.putSync(userSettings));
  }
}

enum Language {
  en(Locale('en')),
  zh(Locale('zh'));

  const Language(this.locale);

  final Locale locale;
}
