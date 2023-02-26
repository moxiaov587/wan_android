import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap.h({
    super.key,
    required double this.value,
    this.backgroundColor,
  })  : direction = _GapDirection.horizontal,
        size = null,
        isVertical = false;

  const Gap.hs({
    super.key,
    this.backgroundColor,
  })  : direction = _GapDirection.horizontal,
        size = _GapSize.small,
        value = null,
        isVertical = false;

  const Gap.hn({
    super.key,
    this.backgroundColor,
  })  : direction = _GapDirection.horizontal,
        size = _GapSize.normal,
        value = null,
        isVertical = false;

  const Gap.hb({
    super.key,
    this.backgroundColor,
  })  : direction = _GapDirection.horizontal,
        size = _GapSize.big,
        value = null,
        isVertical = false;

  const Gap.v({
    super.key,
    required double this.value,
    this.backgroundColor,
  })  : direction = _GapDirection.vertical,
        size = null,
        isVertical = true;

  const Gap.vs({
    super.key,
    this.backgroundColor,
  })  : direction = _GapDirection.vertical,
        size = _GapSize.small,
        value = null,
        isVertical = true;

  const Gap.vn({
    super.key,
    this.backgroundColor,
  })  : direction = _GapDirection.vertical,
        size = _GapSize.normal,
        value = null,
        isVertical = true;

  const Gap.vb({
    super.key,
    this.backgroundColor,
  })  : direction = _GapDirection.vertical,
        size = _GapSize.big,
        value = null,
        isVertical = true;

  final _GapDirection direction;
  final _GapSize? size;
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

enum _GapDirection {
  horizontal,
  vertical,
}

enum _GapSize {
  small(value: 5.0),
  normal(value: 10.0),
  big(value: 20.0);

  const _GapSize({required this.value});

  final double value;
}
