part of '../utils/dialog_utils.dart';

class BaseToast extends StatelessWidget {
  const BaseToast({
    required this.type,
    required this.alignment,
    required this.msg,
    super.key,
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
      case ToastType.danger:
        background = context.theme.colorScheme.error;
      case ToastType.waring:
        background = context.theme.colorScheme.tertiary;
      case ToastType.tips:
        background =
            (context.theme.tooltipTheme.decoration as BoxDecoration?)!.color!;
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
