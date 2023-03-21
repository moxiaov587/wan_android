import 'package:flutter/material.dart';

import '../../extensions/extensions.dart' show BuildContextExtension;
import '../app/theme/app_theme.dart';

class CapsuleInk extends StatelessWidget {
  const CapsuleInk({
    required this.child,
    super.key,
    this.color,
    this.onTap,
  });

  final Color? color;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
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
              child: IconTheme(
                data: const IconThemeData(size: kStyleUint4),
                child: DefaultTextStyle(
                  style: context.theme.textTheme.bodyMedium!.copyWith(
                    height: 1.35,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );
}
