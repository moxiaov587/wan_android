import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../app/l10n/generated/l10n.dart';
import '../app/theme/app_theme.dart';
import '../contacts/instances.dart';
import '../extensions/extensions.dart'
    show BuildContextExtension, TextStyleExtension;
import '../widget/rotate_loading.dart';
import 'screen_utils.dart';

part '../widget/base_toast.dart';
part '../widget/base_confirm.dart';

class DialogUtils {
  DialogUtils._();

  static const AlignmentGeometry _defaultAlignment = Alignment.bottomCenter;

  static Color get _maskBackground => currentTheme.colorScheme.scrim;

  static void loading() => unawaited(
        SmartDialog.showLoading<void>(
          maskColor: _maskBackground,
          builder: (BuildContext context) => const RotateLoading(),
        ),
      );

  static void dismiss({SmartStatus status = SmartStatus.loading}) => unawaited(
        SmartDialog.dismiss<void>(
          status: status,
        ),
      );

  static void tips(
    String msg, {
    AlignmentGeometry? alignment,
  }) =>
      unawaited(
        SmartDialog.showToast(
          '',
          maskColor: _maskBackground,
          builder: (BuildContext context) => BaseToast(
            type: ToastType.tips,
            alignment: alignment ?? _defaultAlignment,
            msg: msg,
          ),
        ),
      );

  static void success(
    String msg, {
    AlignmentGeometry? alignment,
  }) =>
      unawaited(
        SmartDialog.showToast(
          '',
          maskColor: _maskBackground,
          builder: (BuildContext context) => BaseToast(
            type: ToastType.success,
            alignment: alignment ?? _defaultAlignment,
            msg: msg,
          ),
        ),
      );

  static void danger(
    String msg, {
    AlignmentGeometry? alignment,
  }) =>
      unawaited(
        SmartDialog.showToast(
          '',
          maskColor: _maskBackground,
          builder: (BuildContext context) => BaseToast(
            type: ToastType.danger,
            alignment: alignment ?? _defaultAlignment,
            msg: msg,
          ),
        ),
      );

  static void waring(
    String msg, {
    AlignmentGeometry? alignment,
  }) =>
      unawaited(
        SmartDialog.showToast(
          '',
          maskColor: _maskBackground,
          builder: (BuildContext context) => BaseToast(
            type: ToastType.waring,
            alignment: alignment ?? _defaultAlignment,
            msg: msg,
          ),
        ),
      );

  static Future<T?> confirm<T>({
    required Widget Function(BuildContext context) builder,
    required FutureOr<T?> Function() confirmCallback,
    String? title,
    String? confirmText,
    String? cancelText,
    FutureOr<T?> Function()? cancelCallback,
    bool isDanger = false,
    String? tag,
  }) =>
      SmartDialog.show<T>(
        tag: tag,
        maskColor: _maskBackground,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) => BaseConfirm(
          title: title,
          builder: builder,
          confirmText: confirmText,
          cancelText: cancelText,
          confirmHandle: () async {
            final T? result = await confirmCallback.call();
            await SmartDialog.dismiss<T>(
              result: result,
              tag: tag,
            );
          },
          cancelHandle: () async {
            final T? result = await cancelCallback?.call();
            await SmartDialog.dismiss<T>(
              result: result,
              tag: tag,
            );
          },
          isDanger: isDanger,
        ),
      );
}
