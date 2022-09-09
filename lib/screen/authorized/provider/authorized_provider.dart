import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/http.dart';
import '../../../app/http/wan_android_api.dart';
import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/provider.dart';
import '../../../database/database_manager.dart';
import '../../../model/models.dart';
import '../../../utils/dialog_utils.dart' show DialogUtils;

const Map<int, int> _kEncryptOffset = <int, int>{
  2: 7,
  3: 6,
  1: 5,
  5: 4,
  6: 3,
  7: 2,
  0: 1,
  4: 0,
};

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
      accountCache.password = _encryptString(password!);
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

  /// by https://github.com/fluttercandies/flutter_juejin/blob/main/lib/extensions/string_extension.dart
  String _encryptString(String text) {
    return text.split('').map((String w) {
      final int ascii = w.codeUnitAt(0);
      final int remainder = ascii % 8;
      final int offset = _kEncryptOffset[remainder]!;

      return (ascii + offset - remainder).toRadixString(16);
    }).join();
  }

  String decryptString(String text) {
    final Map<int, int> decryptOffset =
        _kEncryptOffset.map((int k, int v) => MapEntry<int, int>(v, k));

    return List<String>.generate(
      text.length ~/ 2,
      (int index) => text.substring(index * 2, index * 2 + 2),
    ).map((String w) {
      final int sum = int.parse(w, radix: 16);
      final int offset = sum % 8;
      final int remainder = decryptOffset[offset]!;
      final int ascii = sum - offset + remainder;

      return String.fromCharCode(ascii);
    }).join();
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
