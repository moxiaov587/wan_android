part of '../utils/dialog_utils.dart';

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
        background = currentTheme.colorScheme.secondary;
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
          color: background.withOpacity(0.7),
          borderRadius: AppTheme.roundedBorderRadius,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 50.0,
        ),
        padding: AppTheme.contentPadding,
        child: Text(
          msg,
          style: currentTheme.textTheme.bodyLarge!.copyWith(
            color: currentIsDark ? AppColors.whiteDark : AppColors.white,
          ),
        ),
      ),
    );
  }
}

enum ToastType {
  success,
  danger,
  waring,
  tips,
}
