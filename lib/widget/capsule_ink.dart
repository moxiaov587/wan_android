import 'package:flutter/material.dart';
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: child,
        ),
        onTap: onTap,
      ),
    );
  }
}
