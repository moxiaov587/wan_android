part of 'theme.dart';

class AppTextTheme {
  AppTextTheme._();

  static const double display1 = 56;
  static const double display2 = 48;
  static const double display3 = 36;
  static const double title1 = 24;
  static const double title2 = 20;
  static const double title3 = 16;
  static const double body1 = 14;
  static const double body2 = 13;
  static const double body3 = 12;
  static const double caption = 12;

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;

  static const TextTheme _base = TextTheme(
    headline6: TextStyle(
      fontSize: title1,
      fontWeight: medium,
    ),
    subtitle1: TextStyle(
      fontSize: title3,
      fontWeight: regular,
    ),
    subtitle2: TextStyle(
      fontSize: body1,
      fontWeight: regular,
    ),
    bodyText1: TextStyle(
      fontSize: body2,
      fontWeight: regular,
    ),
    bodyText2: TextStyle(
      fontSize: body3,
      fontWeight: regular,
    ),
    caption: TextStyle(
      fontSize: caption,
      fontWeight: light,
    ),
    overline: TextStyle(
      fontSize: caption,
      fontWeight: light,
    ),
  );

  static TextTheme get lightTheme => TextTheme(
        headline6: _base.headline6?.copyWith(
          color: AppColor.text1,
        ),
        subtitle1: _base.subtitle1?.copyWith(
          color: AppColor.text2,
        ),
        subtitle2: _base.subtitle1?.copyWith(
          color: AppColor.text2,
        ),
        bodyText1: _base.subtitle1?.copyWith(
          color: AppColor.text3,
        ),
        bodyText2: _base.subtitle1?.copyWith(
          color: AppColor.text3,
        ),
        caption: _base.subtitle1?.copyWith(
          color: AppColor.text3,
        ),
        overline: _base.subtitle1?.copyWith(
          color: AppColor.text4,
        ),
      );

  static TextTheme get darkTheme => TextTheme(
        headline6: _base.headline6?.copyWith(
          color: AppColor.text1Dark,
        ),
        subtitle1: _base.subtitle1?.copyWith(
          color: AppColor.text2Dark,
        ),
        subtitle2: _base.subtitle1?.copyWith(
          color: AppColor.text2Dark,
        ),
        bodyText1: _base.subtitle1?.copyWith(
          color: AppColor.text3Dark,
        ),
        bodyText2: _base.subtitle1?.copyWith(
          color: AppColor.text3Dark,
        ),
        caption: _base.subtitle1?.copyWith(
          color: AppColor.text3Dark,
        ),
        overline: _base.subtitle1?.copyWith(
          color: AppColor.text4Dark,
        ),
      );
}
