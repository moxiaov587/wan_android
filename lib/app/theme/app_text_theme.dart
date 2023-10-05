part of 'app_theme.dart';

class AppTextTheme {
  const AppTextTheme._();

  static const double display1 = 56;
  static const double display2 = 48;
  static const double display3 = 36;
  static const double headline1 = 32;
  static const double headline2 = 28;
  static const double headline3 = 24;
  static const double title1 = 20;
  static const double title2 = 16;
  static const double title3 = 14;
  static const double body1 = 14;
  static const double body2 = 13;
  static const double body3 = 12;
  static const double label1 = 12;
  static const double label2 = 11;
  static const double label3 = 10;

  static const FontWeight thin = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;

  static const TextTheme _base = TextTheme(
    displayLarge: TextStyle(fontSize: display1, fontWeight: semiBold),
    displayMedium: TextStyle(fontSize: display2, fontWeight: medium),
    displaySmall: TextStyle(fontSize: display3, fontWeight: regular),
    headlineLarge: TextStyle(fontSize: headline1, fontWeight: semiBold),
    headlineMedium: TextStyle(fontSize: headline2, fontWeight: medium),
    headlineSmall: TextStyle(fontSize: headline3, fontWeight: regular),
    titleLarge: TextStyle(fontSize: title1, fontWeight: semiBold),
    titleMedium: TextStyle(fontSize: title2, fontWeight: medium),
    titleSmall: TextStyle(fontSize: title3, fontWeight: regular),
    bodyLarge: TextStyle(fontSize: body1, fontWeight: regular),
    bodyMedium: TextStyle(fontSize: body2, fontWeight: semiBold),
    bodySmall: TextStyle(fontSize: body3, fontWeight: medium),
    labelLarge: TextStyle(fontSize: label1, fontWeight: semiBold),
    labelMedium: TextStyle(fontSize: label2, fontWeight: medium),
    labelSmall: TextStyle(fontSize: label3, fontWeight: regular),
  );

  static final TextTheme light = TextTheme(
    displayLarge: _base.displayLarge!.copyWith(color: AppColors.text1),
    displayMedium: _base.displayMedium!.copyWith(color: AppColors.text1),
    displaySmall: _base.displaySmall!.copyWith(color: AppColors.text1),
    headlineLarge: _base.displayLarge!.copyWith(color: AppColors.text1),
    headlineMedium: _base.displayMedium!.copyWith(color: AppColors.text2),
    headlineSmall: _base.displaySmall!.copyWith(color: AppColors.text3),
    titleLarge: _base.titleLarge!.copyWith(color: AppColors.text1),
    titleMedium: _base.titleMedium!.copyWith(color: AppColors.text2),
    titleSmall: _base.titleSmall!.copyWith(color: AppColors.text3),
    bodyLarge: _base.bodyLarge!.copyWith(color: AppColors.text2),
    bodyMedium: _base.bodyMedium!.copyWith(color: AppColors.text3),
    bodySmall: _base.bodySmall!.copyWith(color: AppColors.text4),
    labelLarge: _base.labelLarge!.copyWith(color: AppColors.text3),
    labelMedium: _base.labelMedium!.copyWith(color: AppColors.text4),
    labelSmall: _base.labelSmall!.copyWith(color: AppColors.text4),
  );

  static final TextTheme dark = TextTheme(
    displayLarge: _base.displayLarge!.copyWith(color: AppColors.text1Dark),
    displayMedium: _base.displayMedium!.copyWith(color: AppColors.text1Dark),
    displaySmall: _base.displaySmall!.copyWith(color: AppColors.text1Dark),
    headlineLarge: _base.displayLarge!.copyWith(color: AppColors.text1Dark),
    headlineMedium: _base.displayMedium!.copyWith(color: AppColors.text2Dark),
    headlineSmall: _base.displaySmall!.copyWith(color: AppColors.text3Dark),
    titleLarge: _base.titleLarge!.copyWith(color: AppColors.text1Dark),
    titleMedium: _base.titleMedium!.copyWith(color: AppColors.text2Dark),
    titleSmall: _base.titleSmall!.copyWith(color: AppColors.text3Dark),
    bodyLarge: _base.bodyLarge!.copyWith(color: AppColors.text2Dark),
    bodyMedium: _base.bodyMedium!.copyWith(color: AppColors.text3Dark),
    bodySmall: _base.bodySmall!.copyWith(color: AppColors.text4Dark),
    labelLarge: _base.labelLarge!.copyWith(color: AppColors.text3Dark),
    labelMedium: _base.labelMedium!.copyWith(color: AppColors.text4Dark),
    labelSmall: _base.labelSmall!.copyWith(color: AppColors.text4Dark),
  );
}
