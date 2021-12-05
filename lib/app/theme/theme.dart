import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

part 'color.dart';
part 'text_theme.dart';

class AppTheme {
  AppTheme._();

  static AppBarTheme get appBarTheme => const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      );

  static DividerThemeData get dividerThemeData => const DividerThemeData(
        space: 0,
        thickness: .3,
      );

  static ButtonStyle get buttonStyle => ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
        ),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
        ),
      );

  static ThemeData get light => ThemeData.light().copyWith(
        cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: AppColor.arcoBlue,
        ),
        appBarTheme: appBarTheme.copyWith(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: AppColor.menuBackground,
          foregroundColor: AppColor.text1,
        ),
        primaryColor: AppColor.arcoBlue,
        primaryColorLight: AppColor.primaryLight2,
        primaryColorDark: AppColor.arcoBlue.shade7,
        canvasColor: AppColor.background1,
        shadowColor: AppColor.black,
        scaffoldBackgroundColor: AppColor.background1,
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
        ),
        primaryIconTheme: IconThemeData(
          color: AppColor.text3,
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColor.tooltipBackground,
          ),
        ),
        dividerTheme: dividerThemeData.copyWith(
          color: AppColor.border,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(
              AppColor.arcoBlue,
            ),
          ),
        ),
      );

  static ThemeData get dark => ThemeData.dark().copyWith(
        cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColor.arcoBlueDark,
        ),
        appBarTheme: appBarTheme.copyWith(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: AppColor.menuBackgroundDark,
          foregroundColor: AppColor.text1Dark,
        ),
        primaryColor: AppColor.arcoBlueDark,
        primaryColorLight: AppColor.primaryLight2Dark,
        primaryColorDark: AppColor.arcoBlueDark.shade7,
        canvasColor: AppColor.background1Dark,
        shadowColor: AppColor.white,
        scaffoldBackgroundColor: AppColor.background1Dark,
        bottomAppBarColor: AppColor.background1Dark,
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
        ),
        primaryIconTheme: IconThemeData(
          color: AppColor.text3Dark,
        ),
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColor.tooltipBackgroundDark,
          ),
        ),
        dividerTheme: dividerThemeData.copyWith(
          color: AppColor.borderDark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(
              AppColor.arcoBlueDark,
            ),
          ),
        ),
      );
}
