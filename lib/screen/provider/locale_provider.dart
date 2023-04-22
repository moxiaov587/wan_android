part of 'common_provider.dart';

@Riverpod(dependencies: <Object>[appDatabase])
class AppLanguage extends _$AppLanguage {
  late Isar _isar;

  static const List<Language?> languages = <Language?>[
    null,
    ...Language.values,
  ];

  @override
  Language? build() {
    _isar = ref.read(appDatabaseProvider);

    return _isar.uniqueUserSettings?.language;
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

    unawaited(
      _isar
          .writeTxn<int>(() async => _isar.userSettingsCache.put(userSettings)),
    );
  }
}

enum Language {
  en(Locale('en')),
  zh(Locale('zh'));

  const Language(this.locale);

  final Locale locale;
}
