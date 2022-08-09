part of 'app_theme.dart';

@immutable
class GradientColors extends ThemeExtension<GradientColors> {
  const GradientColors({
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
  });

  factory GradientColors.light() => GradientColors(
        level1: <Color>[
          AppColors.lime,
          AppColors.lime.shade3,
        ],
        level2: <Color>[
          AppColors.blue,
          AppColors.blue.shade3,
        ],
        level3: <Color>[
          AppColors.orange,
          AppColors.orange.shade3,
        ],
        level4: <Color>[
          AppColors.red,
          AppColors.red.shade3,
        ],
      );

  factory GradientColors.dark() => GradientColors(
        level1: <Color>[
          AppColors.limeDark.shade3,
          AppColors.limeDark,
        ],
        level2: <Color>[
          AppColors.blueDark.shade3,
          AppColors.blueDark,
        ],
        level3: <Color>[
          AppColors.orangeDark.shade3,
          AppColors.orangeDark,
        ],
        level4: <Color>[
          AppColors.redDark.shade3,
          AppColors.redDark,
        ],
      );

  final List<Color> level1;
  final List<Color> level2;
  final List<Color> level3;
  final List<Color> level4;

  @override
  ThemeExtension<GradientColors> copyWith({
    List<Color>? level1,
    List<Color>? level2,
    List<Color>? level3,
    List<Color>? level4,
  }) =>
      GradientColors(
        level1: level1 ?? this.level1,
        level2: level2 ?? this.level2,
        level3: level3 ?? this.level3,
        level4: level4 ?? this.level4,
      );

  @override
  ThemeExtension<GradientColors> lerp(
    ThemeExtension<GradientColors>? other,
    double t,
  ) {
    if (other is! GradientColors) {
      return this;
    }

    return GradientColors(
      level1: _lerp(level1, other.level1, t),
      level2: _lerp(level2, other.level2, t),
      level3: _lerp(level3, other.level3, t),
      level4: _lerp(level4, other.level4, t),
    );
  }

  List<Color> _lerp(List<Color> a, List<Color> b, double t) {
    if (a.length != b.length) {
      return a;
    }

    return List<Color>.generate(
      a.length,
      (int index) => Color.lerp(a[index], b[index], t)!,
    );
  }
}
