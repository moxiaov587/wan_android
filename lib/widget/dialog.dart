part of '../utils/dialog.dart';

enum ToastType {
  success,
  danger,
  waring,
  tips,
}

class BaseToast extends StatelessWidget {
  const BaseToast({
    Key? key,
    required this.type,
    required this.alignment,
    required this.msg,
  }) : super(key: key);

  final ToastType type;

  final String msg;

  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    late Color background;

    switch (type) {
      case ToastType.success:
        background = currentTheme.primaryColor;
        break;
      case ToastType.danger:
        background = currentTheme.errorColor;
        break;
      case ToastType.waring:
        background = currentTheme.colorScheme.tertiary;
        break;
      default:
        background =
            (currentTheme.tooltipTheme.decoration as BoxDecoration?)!.color!;
        break;
    }

    return Align(
      alignment: alignment,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 50.0,
        ),
        padding: AppTheme.bodyPadding,
        child: Text(
          msg,
          style: currentTheme.textTheme.bodyLarge!.copyWith(
            color: currentIsDark ? AppColor.whiteDark : AppColor.white,
          ),
        ),
      ),
    );
  }
}

const double _kDialogWidth = 270.0;
const double _kDialogMaxHeight = 240.0;
const double _kDialogContentMinHeight = 60.0;
const double _kDialogBottomActionHeight = 44.0;
const double _kDialogDividerWidth = 1.0;

class BaseConfirm extends StatelessWidget {
  const BaseConfirm({
    Key? key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.confirmHandle,
    required this.cancelHandle,
    required this.isDanger,
  }) : super(key: key);

  final String title;
  final Widget content;
  final String? confirmText;
  final String? cancelText;
  final Function() confirmHandle;
  final Function() cancelHandle;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    const double bottomActionButtonWidth =
        _kDialogWidth / 2 - _kDialogDividerWidth / 2;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 0.0,
        maxHeight: _kDialogMaxHeight,
        minWidth: _kDialogWidth,
        maxWidth: _kDialogWidth,
      ),
      child: Material(
        borderRadius: AppTheme.borderRadius,
        color: currentTheme.backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: AppTheme.contentPadding,
              child: Align(
                child: Text(
                  title,
                  style: currentTheme.textTheme.titleMedium,
                ),
              ),
            ),
            const Divider(
              height: _kDialogDividerWidth,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: _kDialogContentMinHeight,
              ),
              child: Align(
                child: Padding(
                  padding: AppTheme.bodyPadding,
                  child: DefaultTextStyle(
                    style: currentTheme.textTheme.titleSmall!,
                    child: content,
                  ),
                ),
              ),
            ),
            const Divider(
              height: _kDialogDividerWidth,
            ),
            Row(
              children: <Widget>[
                Ink(
                  width: bottomActionButtonWidth,
                  height: _kDialogBottomActionHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: AppTheme.radius,
                    ),
                  ),
                  child: InkWell(
                    onTap: cancelHandle,
                    borderRadius: BorderRadius.only(
                      bottomLeft: AppTheme.radius,
                    ),
                    child: Align(
                      child: Text(
                        cancelText ?? S.of(context).cancel,
                        style: currentTheme.textTheme.titleMedium!.copyWith(
                          color: currentTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: _kDialogDividerWidth,
                  height: _kDialogBottomActionHeight,
                  child: VerticalDivider(
                    width: _kDialogDividerWidth,
                    thickness: AppTheme.dividerTheme.thickness,
                    color: currentTheme.dividerColor,
                  ),
                ),
                Ink(
                  width: bottomActionButtonWidth,
                  height: _kDialogBottomActionHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: AppTheme.radius,
                    ),
                  ),
                  child: InkWell(
                    onTap: confirmHandle,
                    borderRadius: BorderRadius.only(
                      bottomRight: AppTheme.radius,
                    ),
                    child: Align(
                      child: Text(
                        confirmText ??
                            (isDanger
                                ? S.of(context).delete
                                : S.of(context).ok),
                        style: currentTheme.textTheme.titleMedium!.mediumWeight
                            .copyWith(
                          color: isDanger
                              ? currentTheme.errorColor
                              : currentTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
