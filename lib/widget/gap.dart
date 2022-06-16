import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({
    super.key,
    this.direction = GapDirection.vertical,
    this.size = GapSize.normal,
    this.value,
    this.backgroundColor,
  }) : isVertical = direction == GapDirection.vertical;

  final GapDirection direction;
  final GapSize size;
  final double? value;
  final Color? backgroundColor;
  final bool isVertical;

  static const Map<GapSize, double> _sizeToValue = <GapSize, double>{
    GapSize.small: 5,
    GapSize.normal: 10,
    GapSize.big: 20,
  };

  @override
  Widget build(BuildContext context) {
    final double real = value ?? _sizeToValue[size]!;

    return backgroundColor == null
        ? SizedBox(
            width: isVertical ? null : real,
            height: isVertical ? real : null,
          )
        : Container(
            color: backgroundColor,
            width: isVertical ? null : real,
            height: isVertical ? real : null,
          );
  }
}

enum GapDirection {
  horizontal,
  vertical,
}

enum GapSize {
  small,
  normal,
  big,
}
