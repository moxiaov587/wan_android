part of '../utils/dialog_utils.dart';

class BaseToast extends StatelessWidget {
  const BaseToast({
    super.key,
    required this.type,
    required this.alignment,
    required this.msg,
  });

  final ToastType type;

  final String msg;

  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    late Color background;

    switch (type) {
      case ToastType.success:
        background = context.theme.colorScheme.secondary;
        break;
      case ToastType.danger:
        background = context.theme.colorScheme.error;
        break;
      case ToastType.waring:
        background = context.theme.colorScheme.tertiary;
        break;
      case ToastType.tips:
        background =
            (context.theme.tooltipTheme.decoration as BoxDecoration?)!.color!;
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
          style: context.theme.textTheme.bodyLarge!.copyWith(
            color: context.isDarkTheme ? AppColors.whiteDark : AppColors.white,
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
