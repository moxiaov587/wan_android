import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

part 'app_colors.dart';
part 'app_text_theme.dart';

const double _kRadiusValue = 14.0;
const double _kAdornmentRadiusValue = 4.0;
const double _kRoundedRadiusValue = 999.0;

const double kStyleUint = 4.0;
const double kStyleUint2 = kStyleUint * 2;
const double kStyleUint3 = kStyleUint * 3;
const double kStyleUint4 = kStyleUint * 4;

class AppTheme {
  AppTheme._();

  static Radius get radius => const Radius.circular(_kRadiusValue);

  static BorderRadius get borderRadius => BorderRadius.circular(_kRadiusValue);

  static Radius get roundedRadius =>
      const Radius.circular(_kRoundedRadiusValue);

  static BorderRadius get roundedBorderRadius =>
      BorderRadius.circular(_kRoundedRadiusValue);

  static Radius get adornmentRadius =>
      const Radius.circular(_kAdornmentRadiusValue);

  static BorderRadius get adornmentBorderRadius =>
      BorderRadius.circular(_kAdornmentRadiusValue);

  static EdgeInsetsGeometry get bodyPaddingOnlyHorizontal =>
      const EdgeInsets.symmetric(
        horizontal: kStyleUint4,
      );

  static EdgeInsetsGeometry get bodyPaddingOnlyVertical =>
      const EdgeInsets.symmetric(
        vertical: kStyleUint3,
      );

  static EdgeInsetsGeometry get bodyPadding =>
      bodyPaddingOnlyHorizontal.add(bodyPaddingOnlyVertical);

  static EdgeInsetsGeometry get contentPadding => const EdgeInsets.symmetric(
        horizontal: kStyleUint3,
        vertical: kStyleUint2,
      );

  static double get defaultIconSize => 20.0;

  static AppBarTheme get appBarTheme => const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      );

  static DividerThemeData get dividerTheme => const DividerThemeData(
        space: 0,
        thickness: 0.7,
        indent: kStyleUint4,
        endIndent: kStyleUint4,
      );

  static ListTileThemeData get listTileTheme => const ListTileThemeData(
        minLeadingWidth: 24.0,
      );

  static TextStyle get buttonTextStyle => const TextStyle(
        fontSize: AppTextTheme.title3,
        fontWeight: AppTextTheme.medium,
      );

  static BottomAppBarTheme get bottomAppBarTheme => const BottomAppBarTheme(
        elevation: 0.0,
      );

  static BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      const BottomNavigationBarThemeData(
        elevation: 0.0,
      );

  static MaterialStateColor get stateColorLight =>
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

  static MaterialStateColor get stateColorDark =>
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

  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        contentPadding: contentPadding,
        floatingLabelStyle: const TextStyle(
          fontSize: 24.0,
        ),
        hintStyle: AppTextTheme.lightTheme.bodyLarge,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: adornmentBorderRadius,
          borderSide: BorderSide.none,
        ),
      );

  // ignore: long-method
  static ThemeData get light => ThemeData.light().copyWith(
        useMaterial3: true,
        cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: AppColors.primary,
        ),
        appBarTheme: appBarTheme.copyWith(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
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
        textTheme: AppTextTheme.lightTheme,
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
          textStyle: (kIsWeb
                  ? AppTextTheme.lightTheme.overline
                  : AppTextTheme.lightTheme.bodyText2)!
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
            elevation: 0.0,
            primary: AppColors.primary,
            onPrimary: AppColors.white,
            textStyle: buttonTextStyle,
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
        ),
        inputDecorationTheme: inputDecorationTheme.copyWith(
          prefixIconColor: stateColorLight,
          suffixIconColor: stateColorLight,
          fillColor: AppColors.gray.shade1,
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

  // ignore: long-method
  static ThemeData get dark => ThemeData.dark().copyWith(
        useMaterial3: true,
        cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.primaryDark,
        ),
        appBarTheme: appBarTheme.copyWith(
          systemOverlayStyle: SystemUiOverlayStyle.light,
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
        textTheme: AppTextTheme.darkTheme,
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
          textStyle: (kIsWeb
                  ? AppTextTheme.darkTheme.overline
                  : AppTextTheme.darkTheme.bodyText2)!
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
            elevation: 0.0,
            primary: AppColors.primaryDark,
            onPrimary: AppColors.whiteDark,
            textStyle: buttonTextStyle,
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
        ),
        inputDecorationTheme: inputDecorationTheme.copyWith(
          prefixIconColor: stateColorDark,
          suffixIconColor: stateColorDark,
          fillColor: AppColors.grayDark.shade1,
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
