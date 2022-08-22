import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/http.dart';
import '../../../app/http/wan_android_api.dart';
import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/provider.dart';
import '../../../database/database_manager.dart';
import '../../../model/models.dart';
import '../../../utils/dialog_utils.dart' show DialogUtils;

final StateNotifierProvider<AuthorizedNotifier, UserInfoModel?>
    authorizedProvider =
    StateNotifierProvider<AuthorizedNotifier, UserInfoModel?>((_) {
  return AuthorizedNotifier();
});

class AuthorizedNotifier extends StateNotifier<UserInfoModel?>
    with ViewErrorMixin {
  AuthorizedNotifier() : super(null);

  Future<int?> initData() async {
    try {
      if (await Http.isLogin) {
        state = await WanAndroidAPI.fetchUserInfo();
      }

      return null;
    } catch (e, s) {
      Http.cookieJar.deleteAll();

      return getError(e, s).statusCode ?? -1;
    }
  }

  Future<bool> logout() async {
    DialogUtils.loading();
    try {
      await WanAndroidAPI.logout();

      state = null;

      Http.cookieJar.deleteAll();

      return true;
    } catch (e, s) {
      DialogUtils.danger(getError(e, s).errorMessage(S.current.unknownError));

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }

  void _handleCacheByLogin(
    int userId, {
    required String username,
    required String? password,
    required bool rememberPassword,
  }) {
    final AccountCache accountCache = AccountCache()
      ..userId = userId
      ..username = username
      ..updateTime = DateTime.now();

    if (rememberPassword) {
      accountCache.password = password;
    }

    final UserSettings userSettings = DatabaseManager.writeUniqueUserSettings(
      rememberPassword: rememberPassword,
    );

    DatabaseManager.isar.writeTxnSync<void>(
      () {
        DatabaseManager.accountCaches.putSync(accountCache);
        DatabaseManager.userSettingsCache.putSync(userSettings);
      },
    );
  }

  Future<bool> login({
    required String username,
    required String password,
    required bool rememberPassword,
  }) async {
    DialogUtils.loading();
    try {
      final UserModel user = await WanAndroidAPI.login(
        username: username,
        password: password,
      );

      state = await WanAndroidAPI.fetchUserInfo();

      _handleCacheByLogin(
        user.id,
        username: username,
        password: password,
        rememberPassword: rememberPassword,
      );

      DialogUtils.success(S.current.loginSuccess);

      return true;
    } catch (e, s) {
      DialogUtils.danger(
        getError(e, s).errorMessage(S.current.loginFailed),
      );

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }

  Future<bool> register({
    required String username,
    required String password,
    required String repassword,
  }) async {
    DialogUtils.loading();
    try {
      final UserModel model = await WanAndroidAPI.register(
        username: username,
        password: password,
        repassword: repassword,
      );

      final AccountCache accountCache = AccountCache()
        ..userId = model.id
        ..username = username
        ..updateTime = DateTime.now();

      DatabaseManager.isar.writeTxnSync(
        () => DatabaseManager.accountCaches.putSync(
          accountCache,
        ),
      );

      DialogUtils.success(S.current.registerSuccess);

      return true;
    } catch (e, s) {
      DialogUtils.danger(
        getError(e, s).errorMessage(S.current.registerFailed),
      );

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }
}
