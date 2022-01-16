import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../app/l10n/generated/l10n.dart';
import '../app/theme/theme.dart';
import '../contacts/instances.dart';
import '../extensions/extensions.dart' show TextStyleExtension;
import '../widget/loading.dart';

part '../widget/dialog.dart';

class DialogUtils {
  DialogUtils._();

  static const AlignmentGeometry _defaultAlignment = Alignment.bottomCenter;

  static Color get _maskBackground =>
      currentIsDark ? AppColor.maskBackgroundDark : AppColor.maskBackground;

  static void loading() {
    SmartDialog.showLoading(
      background: _maskBackground,
      widget: const RotateLoading(),
    );
  }

  static void dismiss() {
    SmartDialog.dismiss();
  }

  static void tips(
    String msg, {
    AlignmentGeometry? alignment,
  }) {
    SmartDialog.showToast(
      '',
      maskColorTemp: _maskBackground,
      widget: BaseToast(
        type: ToastType.tips,
        alignment: alignment ?? _defaultAlignment,
        msg: msg,
      ),
    );
  }

  static void success(
    String msg, {
    AlignmentGeometry? alignment,
  }) {
    SmartDialog.showToast(
      '',
      maskColorTemp: _maskBackground,
      widget: BaseToast(
        type: ToastType.success,
        alignment: alignment ?? _defaultAlignment,
        msg: msg,
      ),
    );
  }

  static void danger(
    String msg, {
    AlignmentGeometry? alignment,
  }) {
    SmartDialog.showToast(
      '',
      maskColorTemp: _maskBackground,
      widget: BaseToast(
        type: ToastType.danger,
        alignment: alignment ?? _defaultAlignment,
        msg: msg,
      ),
    );
  }

  static void waring(
    String msg, {
    AlignmentGeometry? alignment,
  }) {
    SmartDialog.showToast(
      '',
      maskColorTemp: _maskBackground,
      widget: BaseToast(
        type: ToastType.waring,
        alignment: alignment ?? _defaultAlignment,
        msg: msg,
      ),
    );
  }

  static void confirm({
    String? title,
    required Widget content,
    String? confirmText,
    String? cancelText,
    required Function() confirmCallback,
    Function()? cancelCallback,
    bool isDanger = false,
  }) {
    SmartDialog.show(
      maskColorTemp: _maskBackground,
      widget: BaseConfirm(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmHandle: () {
          SmartDialog.dismiss();
          confirmCallback.call();
        },
        cancelHandle: () {
          SmartDialog.dismiss();
          cancelCallback?.call();
        },
        isDanger: isDanger,
      ),
    );
  }
}
