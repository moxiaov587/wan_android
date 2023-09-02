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

    return ref
        .read(appDatabaseProvider)
        .userSettingsCaches
        .where()
        .userIdEqualTo(userId)
        .findFirst()
        ?.copyWith(userId: userId);
  }

  Future<void> update({
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

    return _isar.writeAsyncWith<void, UserSettingsCache>(
      update,
      (Isar isar, UserSettingsCache obj) {
        isar.userSettingsCaches.put(obj);
      },
    );
  }
}
