import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import '../shape/bottom_app_bar_convex_shape.dart';

part 'color.dart';
part 'text_theme.dart';

class AppTheme {
  AppTheme._();

  static AppBarTheme get appBarTheme => const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      );

  static DividerThemeData get dividerTheme => const DividerThemeData(
        space: 0,
        thickness: .7,
      );

  static ButtonStyle get buttonStyle => ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        minimumSize: MaterialStateProperty.all(const Size(64.0, 44.0)),
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
        ),
        primaryIconTheme: IconThemeData(
          color: AppColor.text3,
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColor.maskBackground,
          ),
          textStyle: (kIsWeb
                  ? AppTextTheme.lightTheme.overline
                  : AppTextTheme.lightTheme.bodyText2)
              ?.copyWith(
            color: AppColor.white,
          ),
        ),
        dividerTheme: dividerTheme.copyWith(
          color: AppColor.border,
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: AppColor.background1,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(
              AppColor.arcoBlue,
            ),
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
      );

  static ThemeData get dark => ThemeData.dark().copyWith(
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
        ),
        primaryIconTheme: IconThemeData(
          color: AppColor.text3Dark,
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColor.maskBackgroundDark,
          ),
          textStyle: (kIsWeb
                  ? AppTextTheme.darkTheme.overline
                  : AppTextTheme.darkTheme.bodyText2)
              ?.copyWith(
            color: AppColor.whiteDark,
          ),
        ),
        dividerTheme: dividerTheme.copyWith(
          color: AppColor.borderDark,
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: AppColor.background2Dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(
              AppColor.arcoBlueDark,
            ),
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
      );
}
