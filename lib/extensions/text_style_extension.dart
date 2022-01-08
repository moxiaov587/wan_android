part of 'extensions.dart';

extension TextStyleExtension on TextStyle {
  TextStyle get lightWeight => copyWith(
        fontWeight: AppTextTheme.light,
      );

  TextStyle get regularWeight => copyWith(
        fontWeight: AppTextTheme.regular,
      );

  TextStyle get mediumWeight => copyWith(
        fontWeight: AppTextTheme.medium,
      );

  TextStyle get semiBoldWeight => copyWith(
        fontWeight: AppTextTheme.semiBold,
      );
}
