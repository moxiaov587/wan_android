/// by zhangxinxu(.com)，可免费商用，保留此注释即可

// ignore_for_file: long-method
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/widgets.dart';

import '../app/theme/app_theme.dart';
import '../extensions/extensions.dart' show BuildContextExtension;

class LevelTag extends StatelessWidget {
  const LevelTag({
    super.key,
    required int? level,
    this.scaleFactor = 1,
    this.isOutlined = false,
  }) : level = level ?? 1;

  final int level;
  final double scaleFactor;
  final bool isOutlined;

  Iterable<String> get integers =>
      level.toString().split('').where((String integer) => integer.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    Size size = Size(16 + integers.length * 8, 16) *
        scaleFactor *
        MediaQuery.of(context).textScaleFactor;

    final double width = size.width * 0.9;
    final double height = size.height - size.width * 0.1;
    Offset padding = Offset(size.width * 0.05, size.width * 0.05);

    if (isOutlined) {
      size = Size(width, height);
      padding = Offset.zero;
    }

    final double unitWidth = width / (integers.length + 2);

    final LinearGradient linearGradient = _getLinearGradientByLevel(context);

    return CustomPaint(
      size: size,
      foregroundPainter: LevelPainter(
        integers: integers,
        color: context.theme.colorScheme.background,
        linearGradient: isOutlined ? linearGradient : null,
        width: width,
        height: height,
        padding: padding,
        unitWidth: unitWidth,
      ),
      painter: isOutlined
          ? null
          : BackgroundPainter(
              integers: integers,
              linearGradient: linearGradient,
              width: width,
              height: height,
              padding: padding,
              unitWidth: unitWidth,
            ),
    );
  }

  LinearGradient _getLinearGradientByLevel(BuildContext context) {
    final GradientColors gradientColors =
        context.theme.extension<GradientColors>()!;

    late List<Color> colors;

    if (level >= 750) {
      colors = gradientColors.level4;
    } else if (level < 750 && level >= 500) {
      colors = gradientColors.level3;
    } else if (level < 500 && level >= 250) {
      colors = gradientColors.level2;
    } else {
      colors = gradientColors.level1;
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }
}

class BackgroundPainter extends CustomPainter {
  const BackgroundPainter({
    required this.integers,
    required this.linearGradient,
    required this.width,
    required this.height,
    required this.padding,
    required this.unitWidth,
  });

  final Iterable<String> integers;
  final LinearGradient linearGradient;

  final double width;
  final double height;
  final Offset padding;
  final double unitWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..addPolygon(
        <Offset>[
          Offset(0, height * 0.2),
          Offset(unitWidth * 1.8 + padding.dx, height * 0.2),
          Offset(unitWidth * 1.8 + padding.dx, 0),
          Offset(size.width, 0),
          Offset(size.width, size.height),
          Offset(0, size.height),
        ],
        true,
      );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..shader = linearGradient.createShader(path.getBounds()),
    );
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) =>
      oldDelegate.integers != integers ||
      oldDelegate.linearGradient != linearGradient ||
      oldDelegate.width != width ||
      oldDelegate.height != height ||
      oldDelegate.padding != padding ||
      oldDelegate.unitWidth != unitWidth;
}

class LevelPainter extends CustomPainter {
  const LevelPainter({
    required this.integers,
    required this.color,
    required this.linearGradient,
    required this.width,
    required this.height,
    required this.padding,
    required this.unitWidth,
  });

  final Iterable<String> integers;
  final Color color;
  final LinearGradient? linearGradient;

  final double width;
  final double height;
  final Offset padding;
  final double unitWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final double word = unitWidth * 0.8;

    final double thickness = word / 3;

    final double dot = unitWidth * 0.4;

    final Path path = integers.foldIndexed(
      Path()
        ..addPolygon(
          <Offset>[
            Offset(0, height * 0.2),
            Offset(thickness, height * 0.2),
            Offset(thickness, height - thickness),
            Offset(word, height - thickness),
            Offset(word, height),
            Offset(0, height),
          ]
              .map((Offset offset) => offset.translate(padding.dx, padding.dy))
              .toList(),
          true,
        )
        ..addPolygon(
          <Offset>[
            Offset(0, height * 0.2),
            Offset(thickness, height * 0.2),
            Offset(thickness, height * 0.6),
            Offset(word * 0.5, height - thickness),
            Offset(thickness * 2, height * 0.6),
            Offset(thickness * 2, height * 0.2),
            Offset(word, height * 0.2),
            Offset(word, height * 0.6),
            Offset(thickness * 2, height),
            Offset(thickness, height),
            Offset(0, height * 0.6),
          ]
              .map((Offset offset) =>
                  offset.translate(word + padding.dx, padding.dy))
              .toList(),
          true,
        )
        ..addPolygon(
          <Offset>[
            Offset(0, height - thickness),
            Offset(thickness, height - thickness),
            Offset(thickness, height),
            Offset(0, height),
          ]
              .map((Offset offset) =>
                  offset.translate(word + word + padding.dx, padding.dy))
              .toList(),
          true,
        ),
      (int index, Path path, String integer) => path
        ..addPolygon(
          _getIntegerPoints(integer, Size(unitWidth * 0.8, height))
              .map((Offset offset) => offset.translate(
                    word + word + dot + padding.dx + (index + 0.2) * unitWidth,
                    padding.dy,
                  ))
              .toList(),
          true,
        ),
    );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color
        ..shader = linearGradient != null
            ? linearGradient!.createShader(path.getBounds())
            : null,
    );
  }

  List<Offset> _getIntegerPoints(String value, Size size) {
    switch (value) {
      case '0':
        return <Offset>[
          Offset.zero,
          Offset(size.width, 0),
          Offset(size.width, size.height),
          Offset(size.width * 0.6, size.height),
          Offset(size.width * 0.6, size.height * 0.2),
          Offset(size.width * 0.4, size.height * 0.2),
          Offset(size.width * 0.4, size.height * 0.8),
          Offset(size.width * 0.6, size.height * 0.8),
          Offset(size.width * 0.6, size.height),
          Offset(0, size.height),
        ];
      case '1':
        return <Offset>[
          Offset.zero,
          Offset(size.width * 0.7, 0),
          Offset(size.width * 0.7, size.height * 0.8),
          Offset(size.width, size.height * 0.8),
          Offset(size.width, size.height),
          Offset(0, size.height),
          Offset(0, size.height * 0.8),
          Offset(size.width * 0.3, size.height * 0.8),
          Offset(size.width * 0.3, size.height * 0.2),
          Offset(0, size.height * 0.2),
        ];
      case '2':
        return <Offset>[
          Offset.zero,
          Offset(size.width, 0),
          Offset(size.width, size.height * 0.6),
          Offset(size.width * 0.5, size.height * 0.6),
          Offset(size.width * 0.5, size.height * 0.8),
          Offset(size.width, size.height * 0.8),
          Offset(size.width, size.height),
          Offset(0, size.height),
          Offset(0, size.height * 0.4),
          Offset(size.width * 0.5, size.height * 0.4),
          Offset(size.width * 0.5, size.height * 0.2),
          Offset(0, size.height * 0.2),
        ];
      case '3':
        return <Offset>[
          Offset.zero,
          Offset(size.width, 0),
          Offset(size.width, size.height),
          Offset(0, size.height),
          Offset(0, size.height * 0.8),
          Offset(size.width * 0.5, size.height * 0.8),
          Offset(size.width * 0.5, size.height * 0.6),
          Offset(0, size.height * 0.6),
          Offset(0, size.height * 0.4),
          Offset(size.width * 0.5, size.height * 0.4),
          Offset(size.width * 0.5, size.height * 0.2),
          Offset(0, size.height * 0.2),
        ];
      case '4':
        return <Offset>[
          Offset.zero,
          Offset(size.width * 0.4, 0),
          Offset(size.width * 0.4, size.height * 0.5),
          Offset(size.width * 0.6, size.height * 0.5),
          Offset(size.width * 0.6, 0),
          Offset(size.width, 0),
          Offset(size.width, size.height),
          Offset(size.width * 0.6, size.height),
          Offset(size.width * 0.6, size.height * 0.7),
          Offset(0, size.height * 0.7),
        ];
      case '5':
        return <Offset>[
          Offset.zero,
          Offset(size.width, 0),
          Offset(size.width, size.height * 0.2),
          Offset(size.width * 0.5, size.height * 0.2),
          Offset(size.width * 0.5, size.height * 0.4),
          Offset(size.width, size.height * 0.4),
          Offset(size.width, size.height),
          Offset(0, size.height),
          Offset(0, size.height * 0.8),
          Offset(size.width * 0.5, size.height * 0.8),
          Offset(size.width * 0.5, size.height * 0.6),
          Offset(0, size.height * 0.6),
        ];
      case '6':
        return <Offset>[
          Offset.zero,
          Offset(size.width, 0),
          Offset(size.width, size.height * 0.2),
          Offset(size.width * 0.4, size.height * 0.2),
          Offset(size.width * 0.4, size.height * 0.8),
          Offset(size.width * 0.6, size.height * 0.8),
          Offset(size.width * 0.6, size.height * 0.6),
          Offset(size.width * 0.4, size.height * 0.6),
          Offset(size.width * 0.4, size.height * 0.4),
          Offset(size.width, size.height * 0.4),
          Offset(size.width, size.height),
          Offset(0, size.height),
        ];
      case '7':
        return <Offset>[
          Offset.zero,
          Offset(size.width, 0),
          Offset(size.width, size.height),
          Offset(size.width * 0.5, size.height),
          Offset(size.width * 0.5, size.height * 0.2),
          Offset(0, size.height * 0.2),
        ];
      case '8':
        return <Offset>[
          Offset.zero,
          Offset(size.width * 0.4, 0),
          Offset(size.width * 0.4, size.height * 0.4),
          Offset(size.width * 0.6, size.height * 0.4),
          Offset(size.width * 0.6, size.height * 0.2),
          Offset(size.width * 0.4, size.height * 0.2),
          Offset(size.width * 0.4, 0),
          Offset(size.width, 0),
          Offset(size.width, size.height),
          Offset(size.width * 0.4, size.height),
          Offset(size.width * 0.4, size.height * 0.8),
          Offset(size.width * 0.6, size.height * 0.8),
          Offset(size.width * 0.6, size.height * 0.6),
          Offset(size.width * 0.4, size.height * 0.6),
          Offset(size.width * 0.4, size.height),
          Offset(0, size.height),
        ];
      case '9':
        return <Offset>[
          Offset.zero,
          Offset(size.width, 0),
          Offset(size.width, size.height),
          Offset(0, size.height),
          Offset(0, size.height * 0.8),
          Offset(size.width * 0.6, size.height * 0.8),
          Offset(size.width * 0.6, size.height * 0.2),
          Offset(size.width * 0.4, size.height * 0.2),
          Offset(size.width * 0.4, size.height * 0.4),
          Offset(size.width * 0.6, size.height * 0.4),
          Offset(size.width * 0.6, size.height * 0.6),
          Offset(0, size.height * 0.6),
        ];
      default:
        return <Offset>[
          Offset.zero,
          Offset(size.width, 0),
          Offset(size.width, size.height),
          Offset(0, size.height),
        ];
    }
  }

  @override
  bool shouldRepaint(LevelPainter oldDelegate) =>
      oldDelegate.integers != integers ||
      oldDelegate.color != color ||
      oldDelegate.linearGradient != linearGradient ||
      oldDelegate.width != width ||
      oldDelegate.height != height ||
      oldDelegate.padding != padding ||
      oldDelegate.unitWidth != unitWidth;
}
