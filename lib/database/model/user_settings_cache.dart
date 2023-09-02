part of 'models.dart';

@freezed
@Collection(accessor: 'userSettingsCaches')
class UserSettingsCache with _$UserSettingsCache {
  const factory UserSettingsCache({
    required int id,
    required DateTime updateTime,
    bool? rememberPassword,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(Language.system) Language language,
    int? userId,
  }) = _UserSettingsCache;
}
