part of 'theme.dart';

class AppTextTheme {
  AppTextTheme._();

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

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;

  static const TextTheme _base = TextTheme(
    displayLarge: TextStyle(
      fontSize: display1,
      fontWeight: regular,
    ),
    displayMedium: TextStyle(
      fontSize: display2,
      fontWeight: regular,
    ),
    displaySmall: TextStyle(
      fontSize: display3,
      fontWeight: regular,
    ),
    headlineLarge: TextStyle(
      fontSize: headline1,
      fontWeight: regular,
    ),
    headlineMedium: TextStyle(
      fontSize: headline2,
      fontWeight: regular,
    ),
    headlineSmall: TextStyle(
      fontSize: headline3,
      fontWeight: regular,
    ),
    titleLarge: TextStyle(
      fontSize: title1,
      fontWeight: regular,
    ),
    titleMedium: TextStyle(
      fontSize: title2,
      fontWeight: regular,
    ),
    titleSmall: TextStyle(
      fontSize: title3,
      fontWeight: regular,
    ),
    bodyLarge: TextStyle(
      fontSize: body1,
      fontWeight: regular,
    ),
    bodyMedium: TextStyle(
      fontSize: body2,
      fontWeight: regular,
    ),
    bodySmall: TextStyle(
      fontSize: body3,
      fontWeight: regular,
    ),
    labelLarge: TextStyle(
      fontSize: label1,
      fontWeight: regular,
    ),
    labelMedium: TextStyle(
      fontSize: label2,
      fontWeight: regular,
    ),
    labelSmall: TextStyle(
      fontSize: label3,
      fontWeight: regular,
    ),
  );

  static TextTheme get lightTheme => TextTheme(
        displayLarge: _base.displayLarge!.copyWith(
          color: AppColor.text1,
        ),
        displayMedium: _base.displayMedium!.copyWith(
          color: AppColor.text1,
        ),
        displaySmall: _base.displaySmall!.copyWith(
          color: AppColor.text1,
        ),
        titleLarge: _base.titleLarge!.copyWith(
          color: AppColor.text2,
        ),
        titleMedium: _base.titleMedium!.copyWith(
          color: AppColor.text2,
        ),
        titleSmall: _base.titleSmall!.copyWith(
          color: AppColor.text2,
        ),
        bodyLarge: _base.bodyLarge!.copyWith(
          color: AppColor.text3,
        ),
        bodyMedium: _base.bodyMedium!.copyWith(
          color: AppColor.text3,
        ),
        bodySmall: _base.bodySmall!.copyWith(
          color: AppColor.text3,
        ),
        labelLarge: _base.labelLarge!.copyWith(
          color: AppColor.text4,
        ),
        labelMedium: _base.labelMedium!.copyWith(
          color: AppColor.text4,
        ),
        labelSmall: _base.labelSmall!.copyWith(
          color: AppColor.text4,
        ),
      );

  static TextTheme get darkTheme => TextTheme(
        displayLarge: _base.displayLarge!.copyWith(
          color: AppColor.text1Dark,
        ),
        displayMedium: _base.displayMedium!.copyWith(
          color: AppColor.text1Dark,
        ),
        displaySmall: _base.displaySmall!.copyWith(
          color: AppColor.text1Dark,
        ),
        titleLarge: _base.titleLarge!.copyWith(
          color: AppColor.text2Dark,
        ),
        titleMedium: _base.titleMedium!.copyWith(
          color: AppColor.text2Dark,
        ),
        titleSmall: _base.titleSmall!.copyWith(
          color: AppColor.text2Dark,
        ),
        bodyLarge: _base.bodyLarge!.copyWith(
          color: AppColor.text3Dark,
        ),
        bodyMedium: _base.bodyMedium!.copyWith(
          color: AppColor.text3Dark,
        ),
        bodySmall: _base.bodySmall!.copyWith(
          color: AppColor.text3Dark,
        ),
        labelLarge: _base.labelLarge!.copyWith(
          color: AppColor.text4Dark,
        ),
        labelMedium: _base.labelMedium!.copyWith(
          color: AppColor.text4Dark,
        ),
        labelSmall: _base.labelSmall!.copyWith(
          color: AppColor.text4Dark,
        ),
      );
}
