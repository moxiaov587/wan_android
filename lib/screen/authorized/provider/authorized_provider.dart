import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../../app/http/wan_android_api.dart';
import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/provider.dart';
import '../../../database/hive_boxes.dart';
import '../../../database/model/models.dart';
import '../../../model/models.dart';

final StateNotifierProvider<AuthorizedNotifier, UserModel?> authorizedProvider =
    StateNotifierProvider<AuthorizedNotifier, UserModel?>((_) {
  return AuthorizedNotifier();
});

class AuthorizedNotifier extends StateNotifier<UserModel?> {
  AuthorizedNotifier() : super(null);

  Future<void> initData() async {
    try {
      final Iterable<AuthorizedCache> authorizedCacheBox =
          HiveBoxes.authorizedCacheBox.values;

      if (authorizedCacheBox.isNotEmpty &&
          authorizedCacheBox.first.password != null) {
        final AuthorizedCache authorizedCache = authorizedCacheBox.first;

        state = await WanAndroidAPI.login(
          username: authorizedCache.username,
          password: authorizedCache.password!,
        );
      }
    } catch (e, s) {
      HiveBoxes.authorizedCacheBox.clear();

      final BaseViewStateError error = BaseViewStateError.create(e, s);

      SmartDialog.showToast(
          S.current.loginInfoInvalidTips(error.statusCode?.toString() ?? '-1'));
    }
  }

  Future<bool> logout() async {
    SmartDialog.showLoading();
    try {
      await WanAndroidAPI.logout();

      state = null;

      return true;
    } catch (e, s) {
      final BaseViewStateError error = BaseViewStateError.create(e, s);

      SmartDialog.showToast(error.message ?? error.detail ?? '');

      return false;
    } finally {
      SmartDialog.dismiss();
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    SmartDialog.showLoading();
    try {
      final UserModel model = await WanAndroidAPI.login(
        username: username,
        password: password,
      );

      await HiveBoxes.authorizedCacheBox.clear();

      await HiveBoxes.authorizedCacheBox.add(
        AuthorizedCache(
          id: model.id,
          username: username,
          password: password,
        ),
      );

      state = model;

      SmartDialog.showToast(S.current.loginSuccess);

      return true;
    } catch (e, s) {
      final BaseViewStateError error = BaseViewStateError.create(e, s);

      SmartDialog.showToast(
          error.message ?? error.detail ?? S.current.loginFailed);

      return false;
    } finally {
      SmartDialog.dismiss();
    }
  }

  Future<bool> register({
    required String username,
    required String password,
    required String rePassword,
  }) async {
    SmartDialog.showLoading();
    try {
      final UserModel model = await WanAndroidAPI.register(
        username: username,
        password: password,
        rePassword: rePassword,
      );

      await HiveBoxes.authorizedCacheBox.clear();

      await HiveBoxes.authorizedCacheBox.add(
        AuthorizedCache(
          id: model.id,
          username: username,
        ),
      );

      SmartDialog.showToast(S.current.registerSuccess);

      return true;
    } catch (e, s) {
      final BaseViewStateError error = BaseViewStateError.create(e, s);

      SmartDialog.showToast(
          error.message ?? error.detail ?? S.current.registerFailed);

      return false;
    } finally {
      SmartDialog.dismiss();
    }
  }
}
