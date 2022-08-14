part of 'models.dart';

@Collection(accessor: 'userSettingsCache')
class UserSettings {
  @Index(unique: true)
  late Id id = Isar.autoIncrement;

  bool? rememberPassword;

  @ThemeModeConverter()
  ThemeMode? themeMode;

  @LocaleConverter()
  Locale? languages;
}
