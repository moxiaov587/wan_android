import 'package:flutter/material.dart';

import '../app/theme/theme.dart';
import '../contacts/instances.dart';

class CapsuleInk extends StatelessWidget {
  const CapsuleInk({
    Key? key,
    this.color,
    required this.child,
    this.onTap,
  }) : super(key: key);

  final Color? color;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: color ?? currentTheme.dialogBackgroundColor,
        borderRadius: AppTheme.roundedBorderRadius,
      ),
      child: InkWell(
        borderRadius: AppTheme.roundedBorderRadius,
        child: Padding(
          padding: AppTheme.contentPadding,
          child: DefaultTextStyle(
            style: currentTheme.textTheme.bodyMedium!.copyWith(
              height: 1.35,
            ),
            child: child,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
