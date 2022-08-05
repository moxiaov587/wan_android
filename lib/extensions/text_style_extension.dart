part of 'extensions.dart';

extension TextStyleExtension on TextStyle {
  TextStyle get thin => copyWith(
        fontWeight: AppTextTheme.thin,
      );

  TextStyle get regular => copyWith(
        fontWeight: AppTextTheme.regular,
      );

  TextStyle get medium => copyWith(
        fontWeight: AppTextTheme.medium,
      );

  TextStyle get semiBold => copyWith(
        fontWeight: AppTextTheme.semiBold,
      );
}
