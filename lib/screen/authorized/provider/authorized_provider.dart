import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/wan_android_api.dart';
import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/provider.dart';
import '../../../database/hive_boxes.dart';
import '../../../database/model/models.dart';
import '../../../model/models.dart';
import '../../../utils/dialog.dart' show DialogUtils;

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

      DialogUtils.tips(
          S.current.loginInfoInvalidTips(error.statusCode?.toString() ?? '-1'));
    }
  }

  Future<bool> logout() async {
    DialogUtils.loading();
    try {
      await WanAndroidAPI.logout();

      state = null;

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
  }) async {
    DialogUtils.loading();
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

      await HiveBoxes.authorizedCacheBox.clear();

      await HiveBoxes.authorizedCacheBox.add(
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
