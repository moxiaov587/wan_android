part of 'common_provider.dart';

@Riverpod(dependencies: <Object>[UserSettings])
class AppLanguage extends _$AppLanguage {
  @override
  Language build() =>
      ref.watch(userSettingsProvider)?.language ?? Language.system;

  void switchLocale(Language language) {
    // state = language;

    unawaited(
      ref.read(userSettingsProvider.notifier).update(language: language),
    );
  }
}

enum Language {
  system(null),
  en(Locale('en')),
  zh(Locale('zh'));

  const Language(this.locale);

  final Locale? locale;
}
