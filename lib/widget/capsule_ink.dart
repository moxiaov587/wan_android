import 'package:flutter/material.dart';

import '../../extensions/extensions.dart' show BuildContextExtension;
import '../app/theme/app_theme.dart';

class CapsuleInk extends StatelessWidget {
  const CapsuleInk({
    super.key,
    this.color,
    required this.child,
    this.onTap,
  });

  final Color? color;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: AppTheme.roundedBorderRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: color ?? context.theme.dialogBackgroundColor,
          borderRadius: AppTheme.roundedBorderRadius,
        ),
        child: InkWell(
          borderRadius: AppTheme.roundedBorderRadius,
          onTap: onTap,
          child: Padding(
            padding: AppTheme.contentPadding,
            child: DefaultTextStyle(
              style: context.theme.textTheme.bodyMedium!.copyWith(
                height: 1.35,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
