import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import '../shape/bottom_app_bar_convex_shape.dart';

part 'color.dart';
part 'text_theme.dart';

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
        thickness: .7,
        indent: kStyleUint4,
        endIndent: kStyleUint4,
      );

  static ListTileThemeData get listTileTheme => const ListTileThemeData(
        minLeadingWidth: 24.0,
      );

  static ButtonStyle get buttonStyle => ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        minimumSize: MaterialStateProperty.all(const Size(64.0, 44.0)),
        padding: MaterialStateProperty.all(contentPadding),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(adornmentRadius),
          ),
        ),
      );

  static TextStyle get buttonTextStyle => const TextStyle(
        fontSize: AppTextTheme.title3,
        fontWeight: AppTextTheme.medium,
      );

  static FloatingActionButtonThemeData get floatingActionButtonTheme =>
      const FloatingActionButtonThemeData(
        elevation: 0.0,
        hoverElevation: 0.0,
        highlightElevation: 0.0,
        sizeConstraints: BoxConstraints.tightFor(width: 56.0, height: 56.0),
      );

  static BottomAppBarTheme get bottomAppBarTheme => const BottomAppBarTheme(
        elevation: 0.0,
        shape: ConvexNotchedRectangle(),
      );

  static BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      const BottomNavigationBarThemeData(
        elevation: 0.0,
      );

  static ThemeData get light => ThemeData.light().copyWith(
        useMaterial3: true,
        cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: AppColor.arcoBlue,
        ),
        appBarTheme: appBarTheme.copyWith(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: AppColor.appBar,
          foregroundColor: AppColor.text1,
        ),
        primaryColor: AppColor.arcoBlue,
        primaryColorLight: AppColor.primaryLight2,
        primaryColorDark: AppColor.arcoBlue.shade7,
        canvasColor: AppColor.background1,
        shadowColor: AppColor.black,
        scaffoldBackgroundColor: AppColor.scaffoldBackground,
        bottomAppBarColor: AppColor.background1,
        cardColor: AppColor.background1,
        dividerColor: AppColor.border,
        focusColor: AppColor.fill3,
        hoverColor: AppColor.fill1,
        highlightColor: Colors.transparent,
        splashColor: AppColor.splash,
        selectedRowColor: AppColor.fill1,
        unselectedWidgetColor: AppColor.fill4,
        disabledColor: AppColor.secondaryDisabled,
        secondaryHeaderColor: AppColor.primaryLight2,
        backgroundColor: AppColor.background1,
        dialogBackgroundColor: AppColor.menuBackground,
        indicatorColor: AppColor.arcoBlue,
        hintColor: AppColor.text4,
        errorColor: AppColor.red,
        toggleableActiveColor: AppColor.arcoBlue,
        textTheme: AppTextTheme.lightTheme,
        iconTheme: IconThemeData(
          color: AppColor.text1,
          size: defaultIconSize,
        ),
        primaryIconTheme: IconThemeData(
          color: AppColor.text3,
          size: defaultIconSize,
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColor.tooltipBackground,
          ),
          textStyle: (kIsWeb
                  ? AppTextTheme.lightTheme.overline
                  : AppTextTheme.lightTheme.bodyText2)!
              .copyWith(
            color: AppColor.white,
          ),
        ),
        dividerTheme: dividerTheme.copyWith(
          color: AppColor.border,
        ),
        listTileTheme: listTileTheme.copyWith(
          tileColor: AppColor.background1,
          selectedTileColor: AppColor.background1,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: adornmentBorderRadius,
          ),
          side: BorderSide(
            color: AppColor.text2,
            width: .7,
          ),
          fillColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColor.text2.withAlpha(100);
            }

            if (states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.focused) ||
                states.contains(MaterialState.selected)) {
              return AppColor.arcoBlue;
            }

            return AppColor.text2;
          }),
          checkColor: MaterialStateProperty.all(AppColor.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(
              AppColor.arcoBlue,
            ),
            textStyle: MaterialStateProperty.all(
              buttonTextStyle.copyWith(
                color: AppColor.white,
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: buttonStyle.copyWith(
            textStyle: MaterialStateProperty.all(buttonTextStyle),
          ),
        ),
        floatingActionButtonTheme: floatingActionButtonTheme.copyWith(
          backgroundColor: AppColor.appBar,
          foregroundColor: AppColor.text2,
        ),
        bottomAppBarTheme: bottomAppBarTheme.copyWith(
          color: AppColor.appBar,
        ),
        bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
          backgroundColor: AppColor.appBar,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.arcoBlue,
          primary: AppColor.arcoBlue,
          onPrimary: AppColor.backgroundWhite,
          primaryContainer: AppColor.arcoBlue.shade2,
          onPrimaryContainer: AppColor.arcoBlue.shade9,
          secondary: AppColor.green,
          onSecondary: AppColor.backgroundWhite,
          secondaryContainer: AppColor.green.shade2,
          onSecondaryContainer: AppColor.green.shade9,
          tertiary: AppColor.orange,
          onTertiary: AppColor.backgroundWhite,
          tertiaryContainer: AppColor.orange.shade2,
          onTertiaryContainer: AppColor.orange.shade9,
          error: AppColor.red,
          onError: AppColor.backgroundWhite,
          errorContainer: AppColor.red.shade2,
          onErrorContainer: AppColor.red.shade9,
          outline: AppColor.text4,
          background: AppColor.backgroundWhite,
          onBackground: AppColor.scaffoldBackground,
          shadow: AppColor.black,
        ),
      );

  static ThemeData get dark => ThemeData.dark().copyWith(
        useMaterial3: true,
        cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColor.arcoBlueDark,
        ),
        appBarTheme: appBarTheme.copyWith(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: AppColor.appBarDark,
          foregroundColor: AppColor.text1Dark,
        ),
        primaryColor: AppColor.arcoBlueDark,
        primaryColorLight: AppColor.primaryLight2Dark,
        primaryColorDark: AppColor.arcoBlueDark.shade7,
        canvasColor: AppColor.background1Dark,
        shadowColor: AppColor.white,
        scaffoldBackgroundColor: AppColor.scaffoldBackgroundDark,
        cardColor: AppColor.background1Dark,
        dividerColor: AppColor.borderDark,
        focusColor: AppColor.fill3Dark,
        hoverColor: AppColor.fill1Dark,
        highlightColor: Colors.transparent,
        splashColor: AppColor.splashDark,
        selectedRowColor: AppColor.fill1Dark,
        unselectedWidgetColor: AppColor.fill4Dark,
        disabledColor: AppColor.secondaryDisabledDark,
        secondaryHeaderColor: AppColor.primaryLight2Dark,
        backgroundColor: AppColor.background1Dark,
        dialogBackgroundColor: AppColor.menuBackgroundDark,
        indicatorColor: AppColor.arcoBlueDark,
        hintColor: AppColor.text4Dark,
        errorColor: AppColor.redDark,
        toggleableActiveColor: AppColor.arcoBlueDark,
        textTheme: AppTextTheme.darkTheme,
        iconTheme: IconThemeData(
          color: AppColor.text1Dark,
          size: defaultIconSize,
        ),
        primaryIconTheme: IconThemeData(
          color: AppColor.text3Dark,
          size: defaultIconSize,
        ),
        tooltipTheme: TooltipThemeData(
          decoration: const BoxDecoration(
            color: AppColor.tooltipBackgroundDark,
          ),
          textStyle: (kIsWeb
                  ? AppTextTheme.darkTheme.overline
                  : AppTextTheme.darkTheme.bodyText2)!
              .copyWith(
            color: AppColor.whiteDark,
          ),
        ),
        dividerTheme: dividerTheme.copyWith(
          color: AppColor.borderDark,
        ),
        listTileTheme: listTileTheme.copyWith(
          tileColor: AppColor.background2Dark,
          selectedTileColor: AppColor.background2Dark,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: adornmentBorderRadius,
          ),
          side: BorderSide(
            color: AppColor.text2Dark,
            width: .7,
          ),
          fillColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColor.text2Dark.withAlpha(100);
            }

            if (states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.focused) ||
                states.contains(MaterialState.selected)) {
              return AppColor.arcoBlueDark;
            }

            return AppColor.text2Dark;
          }),
          checkColor: MaterialStateProperty.all(AppColor.whiteDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(
              AppColor.arcoBlueDark,
            ),
            textStyle: MaterialStateProperty.all(
              buttonTextStyle.copyWith(
                color: AppColor.whiteDark,
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: buttonStyle.copyWith(
            textStyle: MaterialStateProperty.all(buttonTextStyle),
          ),
        ),
        floatingActionButtonTheme: floatingActionButtonTheme.copyWith(
          backgroundColor: AppColor.appBarDark,
          foregroundColor: AppColor.text2Dark,
        ),
        bottomAppBarTheme: bottomAppBarTheme.copyWith(
          color: AppColor.appBarDark,
        ),
        bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
          backgroundColor: AppColor.appBarDark,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.arcoBlueDark,
          brightness: Brightness.dark,
          primary: AppColor.arcoBlueDark,
          onPrimary: AppColor.backgroundWhiteDark,
          primaryContainer: AppColor.arcoBlueDark.shade2,
          onPrimaryContainer: AppColor.arcoBlueDark.shade9,
          secondary: AppColor.greenDark,
          onSecondary: AppColor.backgroundWhiteDark,
          secondaryContainer: AppColor.greenDark.shade2,
          onSecondaryContainer: AppColor.greenDark.shade9,
          tertiary: AppColor.orangeDark,
          onTertiary: AppColor.backgroundWhiteDark,
          tertiaryContainer: AppColor.orangeDark.shade2,
          onTertiaryContainer: AppColor.orangeDark.shade9,
          error: AppColor.redDark,
          onError: AppColor.backgroundWhiteDark,
          errorContainer: AppColor.redDark.shade2,
          onErrorContainer: AppColor.redDark.shade9,
          outline: AppColor.text4Dark,
          background: AppColor.backgroundWhiteDark,
          onBackground: AppColor.scaffoldBackgroundDark,
          shadow: AppColor.blackDark,
        ),
      );
}
