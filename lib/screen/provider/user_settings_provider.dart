part of 'common_provider.dart';

@Riverpod(dependencies: <Object>[appDatabase, Authorized])
class UserSettings extends _$UserSettings {
  late Isar _isar;

  @override
  UserSettingsCache? build() {
    _isar = ref.read(appDatabaseProvider);

    final int? userId = ref.watch(
      authorizedProvider.select(
        (AsyncValue<UserInfoModel?> value) => value.valueOrNull?.user.id,
      ),
    );

    final QueryBuilder<UserSettingsCache, UserSettingsCache, QStart>
        queryBuilder = _isar.userSettingsCaches.where();

    return queryBuilder.userIdEqualTo(userId).findFirst() ??
        // Use the default settings (if exists) when a new user login.
        queryBuilder.userIdEqualTo(null).findFirst()?.copyWith(userId: userId);
  }

  void update({
    bool? rememberPassword,
    ThemeMode? themeMode,
    Language? language,
  }) {
    UserSettingsCache update = state ??
        UserSettingsCache(
          id: _isar.userSettingsCaches.autoIncrement(),
          updateTime: DateTime.now(),
          userId: ref.read(authorizedProvider).valueOrNull?.user.id,
        );

    if (rememberPassword != null) {
      update = update.copyWith(rememberPassword: rememberPassword);
    }

    if (themeMode != null) {
      update = update.copyWith(themeMode: themeMode);
    }

    if (language != null) {
      update = update.copyWith(language: language);
    }

    state = update;

    _isar.write<void>((Isar isar) {
      isar.userSettingsCaches.put(update);
    });
  }
}
