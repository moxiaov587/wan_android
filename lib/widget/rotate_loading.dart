import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../extensions/extensions.dart' show BuildContextExtension;
import '../app/l10n/generated/l10n.dart';
import '../app/theme/app_theme.dart';
import 'gap.dart';

class RotateLoading extends StatefulWidget {
  const RotateLoading({
    super.key,
    this.width = 20.0,
  })  : space = width / 4.0,
        size = width * 6.0;

  final double width;
  final double space;

  final double size;

  @override
  State<RotateLoading> createState() => _RotateLoadingState();
}

class _RotateLoadingState extends State<RotateLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  void initState() {
    super.initState();

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: widget.size,
          height: widget.size,
        ),
        child: Material(
          color: context.theme.colorScheme.background,
          borderRadius: AppTheme.borderRadius,
          child: Padding(
            padding: AppTheme.bodyPadding,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: CustomPaint(
                    size: Size(
                      widget.size * 0.75,
                      widget.size * 0.75,
                    ),
                    painter: RotateLoadingPainter(
                      _animationController,
                      colors: <Color>[
                        context.theme.primaryColor,
                        context.theme.colorScheme.secondary,
                        context.theme.colorScheme.error,
                        context.theme.colorScheme.tertiary,
                      ],
                      width: widget.width,
                      space: widget.space,
                    ),
                  ),
                ),
                const Gap.vn(),
                Text(
                  S.of(context).loading,
                  style: context.theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      );
}

class RotateLoadingPainter extends CustomPainter {
  RotateLoadingPainter(
    this.animation, {
    required this.colors,
    this.width = 20.0,
    this.space = 5.0,
  })  : length = width / 2.0 + space / 2.0,
        super(repaint: animation);

  final double width;
  final double space;

  final double length;

  final Animation<double> animation;

  final List<Color> colors;

  late final List<Offset> offsets = <Offset>[
    Offset(-length, -length),
    Offset(-length, length),
    Offset(length, -length),
    Offset(length, length),
  ];

  final Animatable<double> rotateTween = Tween<double>(
    begin: math.pi,
    end: -math.pi,
  ).chain(
    CurveTween(
      curve: Curves.easeInToLinear,
    ),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final int colorsCount = colors.length;

    canvas
      ..save()
      ..translate(
        size.width / 2,
        size.height / 2,
      )
      ..rotate(animation.value * 2.0 * math.pi);

    for (int index = 0; index < colorsCount; index++) {
      canvas
        ..save()
        ..translate(offsets[index].dx, offsets[index].dy)
        ..rotate(rotateTween.evaluate(animation))
        ..translate(-offsets[index].dx, -offsets[index].dy)
        ..drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: offsets[index],
              width: width,
              height: width,
            ),
            AppTheme.adornmentRadius,
          ),
          paint..color = colors[index],
        )
        ..restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RotateLoadingPainter oldDelegate) =>
      oldDelegate.width != width || oldDelegate.space != space;
}
