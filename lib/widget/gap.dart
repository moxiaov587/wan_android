import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap.h({
    required double this.value,
    super.key,
    this.backgroundColor,
  })  : direction = GapDirection.horizontal,
        size = null,
        isVertical = false;

  const Gap.hs({
    super.key,
    this.backgroundColor,
  })  : direction = GapDirection.horizontal,
        size = GapSize.small,
        value = null,
        isVertical = false;

  const Gap.hn({
    super.key,
    this.backgroundColor,
  })  : direction = GapDirection.horizontal,
        size = GapSize.normal,
        value = null,
        isVertical = false;

  const Gap.hb({
    super.key,
    this.backgroundColor,
  })  : direction = GapDirection.horizontal,
        size = GapSize.big,
        value = null,
        isVertical = false;

  const Gap.v({
    required double this.value,
    super.key,
    this.backgroundColor,
  })  : direction = GapDirection.vertical,
        size = null,
        isVertical = true;

  const Gap.vs({
    super.key,
    this.backgroundColor,
  })  : direction = GapDirection.vertical,
        size = GapSize.small,
        value = null,
        isVertical = true;

  const Gap.vn({
    super.key,
    this.backgroundColor,
  })  : direction = GapDirection.vertical,
        size = GapSize.normal,
        value = null,
        isVertical = true;

  const Gap.vb({
    super.key,
    this.backgroundColor,
  })  : direction = GapDirection.vertical,
        size = GapSize.big,
        value = null,
        isVertical = true;

  final GapDirection direction;
  final GapSize? size;
  final double? value;
  final Color? backgroundColor;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    final double finalValue = value ?? size!.value;

    Widget child = SizedBox(
      width: isVertical ? null : finalValue,
      height: isVertical ? finalValue : null,
    );

    if (backgroundColor != null) {
      child = ColoredBox(color: backgroundColor!, child: child);
    }

    return child;
  }
}

enum GapDirection {
  horizontal,
  vertical,
}

enum GapSize {
  small(value: 5.0),
  normal(value: 10.0),
  big(value: 20.0);

  const GapSize({required this.value});

  final double value;
}
