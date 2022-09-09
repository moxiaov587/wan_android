import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import '../../utils/screen_utils.dart';

part 'app_colors.dart';
part 'app_text_theme.dart';
part 'gradient_colors.dart';

const double _kRadiusValue = 14.0;
const double _kAdornmentRadiusValue = 4.0;
const double _kRoundedRadiusValue = 999.0;

const double kStyleUint = 4.0;
const double kStyleUint2 = kStyleUint * 2;
const double kStyleUint3 = kStyleUint * 3;
const double kStyleUint4 = kStyleUint * 4;

class AppTheme {
  const AppTheme._();

  static const Radius radius = Radius.circular(_kRadiusValue);

  static final BorderRadius borderRadius = BorderRadius.circular(_kRadiusValue);

  static const Radius roundedRadius = Radius.circular(_kRoundedRadiusValue);

  static final BorderRadius roundedBorderRadius =
      BorderRadius.circular(_kRoundedRadiusValue);

  static const Radius adornmentRadius = Radius.circular(_kAdornmentRadiusValue);

  static final BorderRadius adornmentBorderRadius =
      BorderRadius.circular(_kAdornmentRadiusValue);

  static const EdgeInsets confirmDialogContextPadding = EdgeInsets.symmetric(
    horizontal: kStyleUint4,
    vertical: kStyleUint3 * 2,
  );

  static const EdgeInsets bodyPaddingOnlyHorizontal = EdgeInsets.symmetric(
    horizontal: kStyleUint4,
  );

  static const EdgeInsets bodyPaddingOnlyVertical = EdgeInsets.symmetric(
    vertical: kStyleUint3,
  );

  static const EdgeInsets bodyPadding = EdgeInsets.symmetric(
    horizontal: kStyleUint4,
    vertical: kStyleUint3,
  );

  static const EdgeInsets contentPaddingOnlyHorizontal = EdgeInsets.symmetric(
    horizontal: kStyleUint3,
  );

  static const EdgeInsets contentPaddingOnlyVertical = EdgeInsets.symmetric(
    vertical: kStyleUint2,
  );

  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: kStyleUint3,
    vertical: kStyleUint2,
  );

  static const double defaultIconSize = 20.0;

  static const AppBarTheme appBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
  );

  static final DividerThemeData dividerTheme = DividerThemeData(
    space: double.parse((1 / ScreenUtils.scale).toStringAsFixed(2)),
    thickness: double.parse((1 / ScreenUtils.scale).toStringAsFixed(2)),
    indent: kStyleUint4,
    endIndent: kStyleUint4,
  );

  static const ListTileThemeData listTileTheme = ListTileThemeData(
    minLeadingWidth: 24.0,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: AppTextTheme.title3,
    fontWeight: AppTextTheme.medium,
  );

  static const BottomAppBarTheme bottomAppBarTheme = BottomAppBarTheme(
    elevation: 0.0,
  );

  static const BottomNavigationBarThemeData bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    elevation: 0.0,
  );

  static final MaterialStateColor stateColorLight =
      MaterialStateColor.resolveWith((Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return AppColors.text1.withAlpha(100);
    }

    if (states.contains(MaterialState.error)) {
      return AppColors.error;
    }

    if (states.contains(MaterialState.hovered) ||
        states.contains(MaterialState.focused) ||
        states.contains(MaterialState.selected)) {
      return AppColors.primary;
    }

    return AppColors.text1;
  });

  static final MaterialStateColor stateColorDark =
      MaterialStateColor.resolveWith((Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return AppColors.text1Dark.withAlpha(100);
    }

    if (states.contains(MaterialState.error)) {
      return AppColors.errorDark;
    }

    if (states.contains(MaterialState.hovered) ||
        states.contains(MaterialState.focused) ||
        states.contains(MaterialState.selected)) {
      return AppColors.primaryDark;
    }

    return AppColors.text1Dark;
  });

  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    floatingLabelStyle: TextStyle(
      fontSize: AppTextTheme.headline3,
    ),
  );

  static final ThemeData light = ThemeData.light().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      GradientColors.light(),
    ],
    useMaterial3: true,
    cupertinoOverrideTheme: const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
    ),
    appBarTheme: appBarTheme.copyWith(
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      backgroundColor: AppColors.appBar,
      foregroundColor: AppColors.text1,
    ),
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primaryLight2,
    primaryColorDark: AppColors.primary.shade7,
    canvasColor: AppColors.background1,
    shadowColor: AppColors.black,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    bottomAppBarColor: AppColors.background1,
    cardColor: AppColors.background1,
    dividerColor: AppColors.border,
    focusColor: AppColors.fill3,
    hoverColor: AppColors.fill1,
    highlightColor: Colors.transparent,
    splashColor: AppColors.splash,
    selectedRowColor: AppColors.fill1,
    unselectedWidgetColor: AppColors.fill4,
    disabledColor: AppColors.secondaryDisabled,
    secondaryHeaderColor: AppColors.primaryLight2,
    backgroundColor: AppColors.background1,
    dialogBackgroundColor: AppColors.menuBackground,
    indicatorColor: AppColors.primary,
    hintColor: AppColors.text4,
    errorColor: AppColors.error,
    toggleableActiveColor: AppColors.primary,
    textTheme: AppTextTheme.light,
    iconTheme: IconThemeData(
      color: AppColors.text1,
      size: defaultIconSize,
    ),
    primaryIconTheme: IconThemeData(
      color: AppColors.text3,
      size: defaultIconSize,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.tooltipBackground,
      ),
      textStyle:
          (kIsWeb ? AppTextTheme.light.overline : AppTextTheme.light.bodyText2)!
              .copyWith(
        color: AppColors.white,
      ),
    ),
    dividerTheme: dividerTheme.copyWith(
      color: AppColors.border,
    ),
    listTileTheme: listTileTheme.copyWith(
      tileColor: AppColors.background1,
      selectedTileColor: AppColors.background1,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: adornmentBorderRadius,
      ),
      side: BorderSide(
        color: AppColors.text2,
        width: 0.7,
      ),
      fillColor: stateColorLight,
      checkColor: MaterialStateProperty.all(AppColors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: buttonTextStyle,
      ).copyWith(
        elevation: const MaterialStatePropertyAll<double>(0.0),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: buttonTextStyle,
      ),
    ),
    bottomAppBarTheme: bottomAppBarTheme.copyWith(
      color: AppColors.appBar,
    ),
    bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
      backgroundColor: AppColors.appBar,
      selectedItemColor: AppColors.primary,
    ),
    inputDecorationTheme: inputDecorationTheme.copyWith(
      prefixIconColor: stateColorLight,
      suffixIconColor: stateColorLight,
      hintStyle: AppTextTheme.light.bodyLarge,
      enabledBorder: OutlineInputBorder(
        borderRadius: adornmentBorderRadius,
        borderSide: BorderSide(
          color: AppColors.gray.shade4,
          width: dividerTheme.thickness!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: adornmentBorderRadius,
        borderSide: BorderSide(
          color: AppColors.primary,
          width: dividerTheme.thickness!,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: adornmentBorderRadius,
        borderSide: BorderSide(
          color: AppColors.error,
          width: dividerTheme.thickness!,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: adornmentBorderRadius,
        borderSide: BorderSide(
          color: AppColors.error,
          width: dividerTheme.thickness!,
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.backgroundWhite,
      primaryContainer: AppColors.primary.shade2,
      onPrimaryContainer: AppColors.primary.shade9,
      secondary: AppColors.success,
      onSecondary: AppColors.backgroundWhite,
      secondaryContainer: AppColors.success.shade2,
      onSecondaryContainer: AppColors.success.shade9,
      tertiary: AppColors.waring,
      onTertiary: AppColors.backgroundWhite,
      tertiaryContainer: AppColors.waring.shade2,
      onTertiaryContainer: AppColors.waring.shade9,
      error: AppColors.error,
      onError: AppColors.backgroundWhite,
      errorContainer: AppColors.error.shade2,
      onErrorContainer: AppColors.error.shade9,
      outline: AppColors.text4,
      background: AppColors.backgroundWhite,
      onBackground: AppColors.scaffoldBackground,
      shadow: AppColors.black,
    ),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      GradientColors.dark(),
    ],
    useMaterial3: true,
    cupertinoOverrideTheme: const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
    ),
    appBarTheme: appBarTheme.copyWith(
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      backgroundColor: AppColors.appBarDark,
      foregroundColor: AppColors.text1Dark,
    ),
    primaryColor: AppColors.primaryDark,
    primaryColorLight: AppColors.primaryLight2Dark,
    primaryColorDark: AppColors.primaryDark.shade7,
    canvasColor: AppColors.background1Dark,
    shadowColor: AppColors.white,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
    cardColor: AppColors.background1Dark,
    dividerColor: AppColors.borderDark,
    focusColor: AppColors.fill3Dark,
    hoverColor: AppColors.fill1Dark,
    highlightColor: Colors.transparent,
    splashColor: AppColors.splashDark,
    selectedRowColor: AppColors.fill1Dark,
    unselectedWidgetColor: AppColors.fill4Dark,
    disabledColor: AppColors.secondaryDisabledDark,
    secondaryHeaderColor: AppColors.primaryLight2Dark,
    backgroundColor: AppColors.background1Dark,
    dialogBackgroundColor: AppColors.menuBackgroundDark,
    indicatorColor: AppColors.primaryDark,
    hintColor: AppColors.text4Dark,
    errorColor: AppColors.errorDark,
    toggleableActiveColor: AppColors.primaryDark,
    textTheme: AppTextTheme.dark,
    iconTheme: IconThemeData(
      color: AppColors.text1Dark,
      size: defaultIconSize,
    ),
    primaryIconTheme: IconThemeData(
      color: AppColors.text3Dark,
      size: defaultIconSize,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: const BoxDecoration(
        color: AppColors.tooltipBackgroundDark,
      ),
      textStyle:
          (kIsWeb ? AppTextTheme.dark.overline : AppTextTheme.dark.bodyText2)!
              .copyWith(
        color: AppColors.whiteDark,
      ),
    ),
    dividerTheme: dividerTheme.copyWith(
      color: AppColors.borderDark,
    ),
    listTileTheme: listTileTheme.copyWith(
      tileColor: AppColors.background2Dark,
      selectedTileColor: AppColors.background2Dark,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: adornmentBorderRadius,
      ),
      side: BorderSide(
        color: AppColors.text2Dark,
        width: 0.7,
      ),
      fillColor: stateColorDark,
      checkColor: MaterialStateProperty.all(AppColors.whiteDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.whiteDark,
        textStyle: buttonTextStyle,
      ).copyWith(
        elevation: const MaterialStatePropertyAll<double>(0.0),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: buttonTextStyle,
      ),
    ),
    bottomAppBarTheme: bottomAppBarTheme.copyWith(
      color: AppColors.appBarDark,
    ),
    bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
      backgroundColor: AppColors.appBarDark,
      selectedItemColor: AppColors.primaryDark,
    ),
    inputDecorationTheme: inputDecorationTheme.copyWith(
      prefixIconColor: stateColorDark,
      suffixIconColor: stateColorDark,
      hintStyle: AppTextTheme.dark.bodyLarge,
      enabledBorder: OutlineInputBorder(
        borderRadius: adornmentBorderRadius,
        borderSide: BorderSide(
          color: AppColors.grayDark.shade5,
          width: dividerTheme.thickness!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: adornmentBorderRadius,
        borderSide: BorderSide(
          color: AppColors.primaryDark,
          width: dividerTheme.thickness!,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: adornmentBorderRadius,
        borderSide: BorderSide(
          color: AppColors.errorDark,
          width: dividerTheme.thickness!,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: adornmentBorderRadius,
        borderSide: BorderSide(
          color: AppColors.errorDark,
          width: dividerTheme.thickness!,
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryDark,
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.backgroundWhiteDark,
      primaryContainer: AppColors.primaryDark.shade2,
      onPrimaryContainer: AppColors.primaryDark.shade9,
      secondary: AppColors.successDark,
      onSecondary: AppColors.backgroundWhiteDark,
      secondaryContainer: AppColors.successDark.shade2,
      onSecondaryContainer: AppColors.successDark.shade9,
      tertiary: AppColors.waringDark,
      onTertiary: AppColors.backgroundWhiteDark,
      tertiaryContainer: AppColors.waringDark.shade2,
      onTertiaryContainer: AppColors.waringDark.shade9,
      error: AppColors.errorDark,
      onError: AppColors.backgroundWhiteDark,
      errorContainer: AppColors.errorDark.shade2,
      onErrorContainer: AppColors.errorDark.shade9,
      outline: AppColors.text4Dark,
      background: AppColors.backgroundWhiteDark,
      onBackground: AppColors.scaffoldBackgroundDark,
      shadow: AppColors.blackDark,
    ),
  );
}
