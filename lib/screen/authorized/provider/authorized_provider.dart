import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/http.dart';
import '../../../app/http/wan_android_api.dart';
import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/provider.dart';
import '../../../database/hive_boxes.dart';
import '../../../database/model/models.dart';
import '../../../model/models.dart';
import '../../../utils/dialog.dart' show DialogUtils;

final StateNotifierProvider<AuthorizedNotifier, UserInfoModel?>
    authorizedProvider =
    StateNotifierProvider<AuthorizedNotifier, UserInfoModel?>((_) {
  return AuthorizedNotifier();
});

class AuthorizedNotifier extends StateNotifier<UserInfoModel?> {
  AuthorizedNotifier() : super(null);

  Future<void> initData() async {
    try {
      final bool isLogin = HiveBoxes.uniqueUserSettings?.isLogin ?? false;

      if (isLogin) {
        state = await WanAndroidAPI.fetchUserInfo();
      }
    } catch (e, s) {
      final BaseViewStateError error = BaseViewStateError.create(e, s);

      DialogUtils.tips(
          S.current.loginInfoInvalidTips(error.statusCode?.toString() ?? '-1'));
    }
  }

  Future<bool> logout() async {
    DialogUtils.loading();
    try {
      await WanAndroidAPI.logout();

      state = null;

      HttpUtils.cookieJar.deleteAll();

      await HiveBoxes.userSettingsBox.putAt(
        0,
        (HiveBoxes.uniqueUserSettings ?? UserSettings()).copyWith(
          isLogin: false,
        ),
      );

      return true;
    } catch (e, s) {
      final BaseViewStateError error = BaseViewStateError.create(e, s);

      DialogUtils.danger(error.message ?? error.detail ?? '');

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }

  Future<bool> login({
    required String username,
    required String password,
    required bool rememberPassword,
  }) async {
    DialogUtils.loading();
    try {
      final UserModel model = await WanAndroidAPI.login(
        username: username,
        password: password,
      );

      state = await WanAndroidAPI.fetchUserInfo();

      if (rememberPassword) {
        await HiveBoxes.authorizedCacheBox.put(
          model.id,
          AuthorizedCache(
            id: model.id,
            username: username,
            password: password,
          ),
        );

        if (HiveBoxes.uniqueUserSettings == null) {
          await HiveBoxes.userSettingsBox.add(
            UserSettings(
              isLogin: true,
              rememberPassword: true,
            ),
          );
        } else {
          await HiveBoxes.userSettingsBox.putAt(
            0,
            HiveBoxes.uniqueUserSettings!.copyWith(
              isLogin: true,
              rememberPassword: true,
            ),
          );
        }
      } else {
        await HiveBoxes.authorizedCacheBox.put(
          model.id,
          AuthorizedCache(
            id: model.id,
            username: username,
          ),
        );

        if (HiveBoxes.uniqueUserSettings != null &&
            HiveBoxes.uniqueUserSettings!.rememberPassword) {
          await HiveBoxes.userSettingsBox.putAt(
            0,
            HiveBoxes.uniqueUserSettings!.copyWith(
              isLogin: true,
              rememberPassword: false,
            ),
          );
        }
      }

      DialogUtils.success(S.current.loginSuccess);

      return true;
    } catch (e, s) {
      final BaseViewStateError error = BaseViewStateError.create(e, s);

      DialogUtils.danger(
          error.message ?? error.detail ?? S.current.loginFailed);

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }

  Future<bool> register({
    required String username,
    required String password,
    required String rePassword,
  }) async {
    DialogUtils.loading();
    try {
      final UserModel model = await WanAndroidAPI.register(
        username: username,
        password: password,
        rePassword: rePassword,
      );

      await HiveBoxes.authorizedCacheBox.put(
        model.id,
        AuthorizedCache(
          id: model.id,
          username: username,
        ),
      );

      DialogUtils.success(S.current.registerSuccess);

      return true;
    } catch (e, s) {
      final BaseViewStateError error = BaseViewStateError.create(e, s);

      DialogUtils.danger(
          error.message ?? error.detail ?? S.current.registerFailed);

      return false;
    } finally {
      DialogUtils.dismiss();
    }
  }
}
