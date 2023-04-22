import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/http/http.dart';
import '../../../app/http/interceptors/interceptors.dart';
import '../../../app/l10n/generated/l10n.dart';
import '../../../database/app_database.dart';
import '../../../model/models.dart';
import '../../../utils/dialog_utils.dart' show DialogUtils;

part 'authorized_provider.g.dart';

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

@Riverpod(keepAlive: true, dependencies: <Object>[appDatabase])
class Authorized extends _$Authorized {
  late Http _http;
  late Isar _isar;

  @override
  Future<UserInfoModel?> build() async {
    final CancelToken cancelToken = ref.cancelToken();

    _http = ref.watch(networkProvider);
    _isar = ref.read(appDatabaseProvider);

    if (await _http.isLogin) {
      return _http.fetchUserInfo(cancelToken: cancelToken);
    }

    return null;
  }

  Future<List<int>> _handleCacheByLogin(
    int userId, {
    required String username,
    required String password,
    required bool rememberPassword,
  }) {
    final AccountCache accountCache = AccountCache()
      ..userId = userId
      ..username = username
      ..updateTime = DateTime.now();

    if (rememberPassword) {
      accountCache.password = _encryptString(password);
    }

    final UserSettings userSettings = _isar.writeUniqueUserSettings(
      rememberPassword: rememberPassword,
    );

    return _isar.writeTxn(
      () async => Future.wait<int>(
        <Future<int>>[
          _isar.accountCaches.put(accountCache),
          _isar.userSettingsCache.put(userSettings),
        ],
      ),
    );
  }

  /// by https://github.com/fluttercandies/flutter_juejin/blob/main/lib/extensions/string_extension.dart
  String _encryptString(String text) => text.split('').map((String w) {
        final int ascii = w.codeUnitAt(0);
        final int remainder = ascii % 8;
        final int offset = _kEncryptOffset[remainder]!;

        return (ascii + offset - remainder).toRadixString(16);
      }).join();

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

    state = await AsyncValue.guard<UserInfoModel?>(() async {
      final UserModel user = await _http.login(
        username: username,
        password: password,
      );

      final UserInfoModel userInfo = await _http.fetchUserInfo();

      unawaited(
        _handleCacheByLogin(
          user.id,
          username: username,
          password: password,
          rememberPassword: rememberPassword,
        ),
      );

      return userInfo;
    });

    if (state.hasError) {
      DialogUtils.danger(
        AppException.create(state.error!, state.stackTrace)
            .errorMessage(S.current.loginFailed),
      );
    }
    DialogUtils.dismiss();

    return state.hasValue;
  }

  Future<bool> silentLogin({
    required String username,
    required String password,
  }) async {
    password = decryptString(password);

    state = await AsyncValue.guard<UserInfoModel?>(() async {
      final UserModel user = await _http.silentLogin(
        username: username,
        password: password,
      );

      final UserInfoModel userInfo = await _http.silentFetchUserInfo();

      unawaited(
        _handleCacheByLogin(
          user.id,
          username: username,
          password: password,
          rememberPassword: true,
        ),
      );

      return userInfo;
    });

    return state.hasValue;
  }

  Future<bool> logout() async {
    DialogUtils.loading();
    state = await AsyncValue.guard<UserInfoModel?>(() async {
      await _http.logout();
      await _http.cookieJar.deleteAll();

      return null;
    });

    if (state.hasError) {
      DialogUtils.danger(
        AppException.create(state.error!, state.stackTrace)
            .errorMessage(S.current.unknownError),
      );
    }

    DialogUtils.dismiss();

    return state.hasValue;
  }

  Future<bool> register({
    required String username,
    required String password,
    required String repassword,
  }) async {
    DialogUtils.loading();
    try {
      final UserModel model = await _http.register(
        username: username,
        password: password,
        repassword: repassword,
      );

      final AccountCache accountCache = AccountCache()
        ..userId = model.id
        ..username = username
        ..updateTime = DateTime.now();

      unawaited(_isar.writeTxn(() => _isar.accountCaches.put(accountCache)));

      DialogUtils.success(S.current.registerSuccess);

      return true;
    } on Exception catch (e, s) {
      DialogUtils.danger(
        AppException.create(e, s).errorMessage(S.current.registerFailed),
      );

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }
}
