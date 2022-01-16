part of 'models.dart';

@HiveType(typeId: HiveAdapterTypeIds.userSettings)
class UserSettings extends HiveObject {
  UserSettings({
    this.isLogin = false,
    this.rememberPassword = false,
    this.themeMode = 0,
    this.languages = '',
  });

  UserSettings copyWith({
    bool? isLogin,
    bool? rememberPassword,
    int? themeMode,
    String? languages,
  }) {
    return UserSettings(
      isLogin: isLogin ?? this.isLogin,
      rememberPassword: rememberPassword ?? this.rememberPassword,
      themeMode: themeMode ?? this.themeMode,
      languages: languages ?? this.languages,
    );
  }

  @HiveField(0)
  bool isLogin;
  @HiveField(1)
  bool rememberPassword;

  /// 0 is [ThemeMode.system]
  /// 1 is [ThemeMode.light]
  /// 2 is [ThemeMode.dark]
  @HiveField(2)
  int themeMode;

  /// eg. "en" "zh,CN"
  @HiveField(3)
  String languages;

  @override
  String toString() =>
      '$runtimeType (isLogin: $isLogin, rememberPassword: $rememberPassword, '
      'themeMode: $themeMode, languages: $languages)';
}
