part of 'models.dart';

@Collection(accessor: 'userSettingsCache')
class UserSettings {
  @Index(unique: true)
  late Id id = Isar.autoIncrement;

  bool? rememberPassword;

  @Enumerated(EnumType.name)
  ThemeMode? themeMode;

  @Enumerated(EnumType.name)
  Language? language;
}
