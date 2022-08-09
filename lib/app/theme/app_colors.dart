part of 'app_theme.dart';

class AppColors {
  const AppColors._();

  static const Color white = Color(0xffffffff);
  static final Color whiteDark = white.withOpacity(0.9);

  static const Color black = Color(0xff000000);
  static const Color blackDark = Color(0xff000000);

  static final Color maskBackground = gray.shade10.withOpacity(0.6);
  static final Color maskBackgroundDark = grayDark.shade1.withOpacity(0.6);

  static const Color menuBackground = white;
  static const Color menuBackgroundDark = background2Dark;

  static final Color tooltipBackground = gray.shade10;
  static const Color tooltipBackgroundDark = background5Dark;

  static final Color border = gray.shade3;
  static const Color borderDark = Color(0xff333335);

  static const Color background1 = white;
  static const Color background2 = white;
  static const Color background3 = white;
  static const Color background4 = white;
  static const Color background5 = white;
  static const Color backgroundWhite = white;

  static final Color background1Dark = grayDark.shade1;
  static const Color background2Dark = Color(0xff232324);
  static const Color background3Dark = Color(0xff2a2a2b);
  static const Color background4Dark = Color(0xff313132);
  static const Color background5Dark = Color(0xff373739);
  static const Color backgroundWhiteDark = Color(0xfff6f6f6);

  static final Color text1 = gray.shade10;
  static final Color text2 = gray.shade8;
  static final Color text3 = gray.shade6;
  static final Color text4 = gray.shade4;

  static final Color text1Dark = white.withOpacity(0.9);
  static final Color text2Dark = white.withOpacity(0.7);
  static final Color text3Dark = white.withOpacity(0.5);
  static final Color text4Dark = white.withOpacity(0.3);

  static final Color fill1 = gray.shade1;
  static final Color fill2 = gray.shade2;
  static final Color fill3 = gray.shade3;
  static final Color fill4 = gray.shade4;

  static final Color fill1Dark = white.withOpacity(0.04);
  static final Color fill2Dark = white.withOpacity(0.08);
  static final Color fill3Dark = white.withOpacity(0.12);
  static final Color fill4Dark = white.withOpacity(0.16);

  static final Color primaryLight1 = arcoBlue.shade1;
  static final Color primaryLight2 = arcoBlue.shade2;
  static final Color primaryLight3 = arcoBlue.shade3;
  static final Color primaryLight4 = arcoBlue.shade4;

  static final Color primaryLight1Dark = arcoBlueDark.shade6.withOpacity(0.2);
  static final Color primaryLight2Dark = arcoBlueDark.shade6.withOpacity(0.35);
  static final Color primaryLight3Dark = arcoBlueDark.shade6.withOpacity(0.5);
  static final Color primaryLight4Dark = arcoBlueDark.shade6.withOpacity(0.65);

  static final Color secondary = gray.shade2;
  static final Color secondaryHover = gray.shade3;
  static final Color secondaryActive = gray.shade4;
  static final Color secondaryDisabled = gray.shade1;

  static final Color secondaryDark = grayDark.shade9.withOpacity(0.08);
  static final Color secondaryHoverDark = grayDark.shade8.withOpacity(0.16);
  static final Color secondaryActiveDark = grayDark.shade7.withOpacity(0.24);
  static final Color secondaryDisabledDark = grayDark.shade9.withOpacity(0.09);

  static const ArcoColor primary = arcoBlue;
  static const ArcoColor success = green;
  static const ArcoColor waring = orange;
  static const ArcoColor error = red;

  static const ArcoColor primaryDark = arcoBlueDark;
  static const ArcoColor successDark = greenDark;
  static const ArcoColor waringDark = orangeDark;
  static const ArcoColor errorDark = redDark;

  static final Color splash = gray.shade4.withAlpha(50);
  static final Color splashDark = gray.shade7.withAlpha(50);

  static const Color appBar = Color(0xfff2f3f6);
  static const Color appBarDark = background4Dark;

  static const Color scaffoldBackground = Color(0xffe9e9eb);
  static const Color scaffoldBackgroundDark = background5Dark;

  static const ArcoColor red = ArcoColor(_redPrimaryValue, <int, Color>{
    1: Color(0xffffece8),
    2: Color(0xfffdcdc5),
    3: Color(0xfffbaca3),
    4: Color(0xfff98981),
    5: Color(0xfff76560),
    6: Color(_redPrimaryValue),
    7: Color(0xffcb272d),
    8: Color(0xffa1151e),
    9: Color(0xff770813),
    10: Color(0xff4d000a),
  });
  static const int _redPrimaryValue = 0xfff53f3f;

  static const ArcoColor orangeRed =
      ArcoColor(_orangeRedPrimaryValue, <int, Color>{
    1: Color(0xfffff3e8),
    2: Color(0xfffdddc3),
    3: Color(0xfffcc59f),
    4: Color(0xfffaac7b),
    5: Color(0xfff99057),
    6: Color(_orangeRedPrimaryValue),
    7: Color(0xffcc5120),
    8: Color(0xffa23511),
    9: Color(0xff771f06),
    10: Color(0xff4d0e00),
  });
  static const int _orangeRedPrimaryValue = 0xfff77234;

  static const ArcoColor orange = ArcoColor(_orangePrimaryValue, <int, Color>{
    1: Color(0xfffff7e8),
    2: Color(0xffffe4ba),
    3: Color(0xffffcf8b),
    4: Color(0xffffb65d),
    5: Color(0xffff9a2e),
    6: Color(_orangePrimaryValue),
    7: Color(0xffd25f00),
    8: Color(0xffa64500),
    9: Color(0xff792e00),
    10: Color(0xff4d1b00),
  });
  static const int _orangePrimaryValue = 0xffff7d00;

  static const ArcoColor gold = ArcoColor(_goldPrimaryValue, <int, Color>{
    1: Color(0xfffffce8),
    2: Color(0xfffdf4bf),
    3: Color(0xfffce996),
    4: Color(0xfffadc6d),
    5: Color(0xfff9cc45),
    6: Color(_goldPrimaryValue),
    7: Color(0xffcc9213),
    8: Color(0xffa26d0a),
    9: Color(0xff774b04),
    10: Color(0xff4d2d00),
  });
  static const int _goldPrimaryValue = 0xfff7ba1e;

  static const ArcoColor yellow = ArcoColor(_yellowPrimaryValue, <int, Color>{
    1: Color(0xfffeffe8),
    2: Color(0xfffefebe),
    3: Color(0xfffdfa94),
    4: Color(0xfffcf26b),
    5: Color(0xfffbe842),
    6: Color(_yellowPrimaryValue),
    7: Color(0xffcfaf0f),
    8: Color(0xffa38408),
    9: Color(0xff785d03),
    10: Color(0xff4d3800),
  });
  static const int _yellowPrimaryValue = 0xfffadc19;

  static const ArcoColor lime = ArcoColor(_limePrimaryValue, <int, Color>{
    1: Color(0xfffcffe8),
    2: Color(0xffedf8bb),
    3: Color(0xffdcf190),
    4: Color(0xffc9e968),
    5: Color(0xffb5e241),
    6: Color(_limePrimaryValue),
    7: Color(0xff7eb712),
    8: Color(0xff5f940a),
    9: Color(0xff437004),
    10: Color(0xff2a4d00),
  });
  static const int _limePrimaryValue = 0xff9fdb1d;

  static const ArcoColor green = ArcoColor(_greenPrimaryValue, <int, Color>{
    1: Color(0xffe8ffea),
    2: Color(0xffaff0b5),
    3: Color(0xff7be188),
    4: Color(0xff4cd263),
    5: Color(0xff23c343),
    6: Color(_greenPrimaryValue),
    7: Color(0xff009a29),
    8: Color(0xff008026),
    9: Color(0xff006622),
    10: Color(0xff004d1c),
  });
  static const int _greenPrimaryValue = 0xff00b42a;

  static const ArcoColor cyan = ArcoColor(_cyanPrimaryValue, <int, Color>{
    1: Color(0xffe8fffb),
    2: Color(0xffb7f4ec),
    3: Color(0xff89e9e0),
    4: Color(0xff5edfd6),
    5: Color(0xff37d4cf),
    6: Color(_cyanPrimaryValue),
    7: Color(0xff0da5aa),
    8: Color(0xff07828b),
    9: Color(0xff03616c),
    10: Color(0xff00424d),
  });
  static const int _cyanPrimaryValue = 0xff14c9c9;

  static const ArcoColor blue = ArcoColor(_bluePrimaryValue, <int, Color>{
    1: Color(0xffe8f7ff),
    2: Color(0xffc3e7fe),
    3: Color(0xff9fd4fd),
    4: Color(0xff7bc0fc),
    5: Color(0xff57a9fb),
    6: Color(_bluePrimaryValue),
    7: Color(0xff206ccf),
    8: Color(0xff114ba3),
    9: Color(0xff063078),
    10: Color(0xff001a4d),
  });
  static const int _bluePrimaryValue = 0xff3491fa;

  static const ArcoColor arcoBlue =
      ArcoColor(_arcoBluePrimaryValue, <int, Color>{
    1: Color(0xffe8f3ff),
    2: Color(0xffbedaff),
    3: Color(0xff94bfff),
    4: Color(0xff6aa1ff),
    5: Color(0xff4080ff),
    6: Color(_arcoBluePrimaryValue),
    7: Color(0xff0e42d2),
    8: Color(0xff072ca6),
    9: Color(0xff031a79),
    10: Color(0xff000d4d),
  });
  static const int _arcoBluePrimaryValue = 0xff165dff;

  static const ArcoColor purple = ArcoColor(_purplePrimaryValue, <int, Color>{
    1: Color(0xfff5e8ff),
    2: Color(0xffddbef6),
    3: Color(0xffc396ed),
    4: Color(0xffa871e3),
    5: Color(0xff8d4eda),
    6: Color(_purplePrimaryValue),
    7: Color(0xff551db0),
    8: Color(0xff3c108f),
    9: Color(0xff27066e),
    10: Color(0xff16004d),
  });
  static const int _purplePrimaryValue = 0xff722ed1;

  static const ArcoColor pinkPurple =
      ArcoColor(_pinkPurplePrimaryValue, <int, Color>{
    1: Color(0xffffe8fb),
    2: Color(0xfff7baef),
    3: Color(0xfff08ee6),
    4: Color(0xffe865df),
    5: Color(0xffe13edb),
    6: Color(_pinkPurplePrimaryValue),
    7: Color(0xffb010b6),
    8: Color(0xff8a0993),
    9: Color(0xff650370),
    10: Color(0xff42004d),
  });
  static const int _pinkPurplePrimaryValue = 0xffd91ad9;

  static const ArcoColor magenta = ArcoColor(_magentaPrimaryValue, <int, Color>{
    1: Color(0xffffe8f1),
    2: Color(0xfffdc2db),
    3: Color(0xfffb9dc7),
    4: Color(0xfff979b7),
    5: Color(0xfff754a8),
    6: Color(_magentaPrimaryValue),
    7: Color(0xffcb1e83),
    8: Color(0xffa11069),
    9: Color(0xff77064f),
    10: Color(0xff4d0034),
  });
  static const int _magentaPrimaryValue = 0xfff5319d;

  static const ArcoColor gray = ArcoColor(_grayPrimaryValue, <int, Color>{
    1: Color(0xfff7f8fa),
    2: Color(0xfff2f3f5),
    3: Color(0xffe5e6eb),
    4: Color(0xffc9cdd4),
    5: Color(0xffa9aeb8),
    6: Color(_grayPrimaryValue),
    7: Color(0xff6b7785),
    8: Color(0xff4e5969),
    9: Color(0xff272e3b),
    10: Color(0xff1d2129),
  });
  static const int _grayPrimaryValue = 0xff86909c;

  static const ArcoColor redDark = ArcoColor(_redDarkPrimaryValue, <int, Color>{
    1: Color(0xff4d000a),
    2: Color(0xff770611),
    3: Color(0xffa1161f),
    4: Color(0xffcb2e34),
    5: Color(0xfff54e4e),
    6: Color(_redDarkPrimaryValue),
    7: Color(0xfff98d86),
    8: Color(0xfffbb0a7),
    9: Color(0xfffdd1ca),
    10: Color(0xfffff0ec),
  });
  static const int _redDarkPrimaryValue = 0xfff76965;

  static const ArcoColor orangeRedDark =
      ArcoColor(_orangeRedDarkPrimaryValue, <int, Color>{
    1: Color(0xff4d0e00),
    2: Color(0xff771e05),
    3: Color(0xffa23714),
    4: Color(0xffcc5729),
    5: Color(0xfff77e45),
    6: Color(_orangeRedDarkPrimaryValue),
    7: Color(0xfffaad7d),
    8: Color(0xfffcc6a1),
    9: Color(0xfffddec5),
    10: Color(0xfffff4eb),
  });
  static const int _orangeRedDarkPrimaryValue = 0xfff9925a;

  static const ArcoColor orangeDark =
      ArcoColor(_orangeDarkPrimaryValue, <int, Color>{
    1: Color(0xff4d1b00),
    2: Color(0xff793004),
    3: Color(0xffa64b0a),
    4: Color(0xffd26913),
    5: Color(0xffff8b1f),
    6: Color(_orangeDarkPrimaryValue),
    7: Color(0xffffb357),
    8: Color(0xffffcd87),
    9: Color(0xffffe3b8),
    10: Color(0xfffff7e8),
  });
  static const int _orangeDarkPrimaryValue = 0xffff9626;

  static const ArcoColor goldDark =
      ArcoColor(_goldDarkPrimaryValue, <int, Color>{
    1: Color(0xff4d2d00),
    2: Color(0xff774b04),
    3: Color(0xffa26f0f),
    4: Color(0xffcc961f),
    5: Color(0xfff7c034),
    6: Color(_goldDarkPrimaryValue),
    7: Color(0xfffadc6c),
    8: Color(0xfffce995),
    9: Color(0xfffdf4be),
    10: Color(0xfffffce8),
  });
  static const int _goldDarkPrimaryValue = 0xfff9cc44;

  static const ArcoColor yellowDark =
      ArcoColor(_yellowDarkPrimaryValue, <int, Color>{
    1: Color(0xff4d3800),
    2: Color(0xff785e07),
    3: Color(0xffa38614),
    4: Color(0xffcfb325),
    5: Color(0xfffae13c),
    6: Color(_yellowDarkPrimaryValue),
    7: Color(0xfffcf374),
    8: Color(0xfffdfa9d),
    9: Color(0xfffefec6),
    10: Color(0xfffefff0),
  });
  static const int _yellowDarkPrimaryValue = 0xfffbe94b;

  static const ArcoColor limeDark =
      ArcoColor(_limeDarkPrimaryValue, <int, Color>{
    1: Color(0xff2a4d00),
    2: Color(0xff447006),
    3: Color(0xff629412),
    4: Color(0xff84b723),
    5: Color(0xffa8db39),
    6: Color(_limeDarkPrimaryValue),
    7: Color(0xffcbe970),
    8: Color(0xffdef198),
    9: Color(0xffeef8c2),
    10: Color(0xfffdffee),
  });
  static const int _limeDarkPrimaryValue = 0xffb8e24b;

  static const ArcoColor greenDark =
      ArcoColor(_greenDarkPrimaryValue, <int, Color>{
    1: Color(0xff004d1c),
    2: Color(0xff046625),
    3: Color(0xff0a802d),
    4: Color(0xff129a37),
    5: Color(0xff1db440),
    6: Color(_greenDarkPrimaryValue),
    7: Color(0xff50d266),
    8: Color(0xff7ee18b),
    9: Color(0xffb2f0b7),
    10: Color(0xffebffec),
  });
  static const int _greenDarkPrimaryValue = 0xff27c346;

  static const ArcoColor cyanDark =
      ArcoColor(_cyanDarkPrimaryValue, <int, Color>{
    1: Color(0xff00424d),
    2: Color(0xff06616c),
    3: Color(0xff11838b),
    4: Color(0xff1fa6aa),
    5: Color(0xff30c9c9),
    6: Color(_cyanDarkPrimaryValue),
    7: Color(0xff66dfd7),
    8: Color(0xff90e9e1),
    9: Color(0xffbef4ed),
    10: Color(0xfff0fffc),
  });
  static const int _cyanDarkPrimaryValue = 0xff3fd4cf;

  static const ArcoColor blueDark =
      ArcoColor(_blueDarkPrimaryValue, <int, Color>{
    1: Color(0xff001a4d),
    2: Color(0xff052f78),
    3: Color(0xff134ca3),
    4: Color(0xff2971cf),
    5: Color(0xff4699fa),
    6: Color(_blueDarkPrimaryValue),
    7: Color(0xff7dc1fc),
    8: Color(0xffa1d5fd),
    9: Color(0xffc6e8fe),
    10: Color(0xffeaf8ff),
  });
  static const int _blueDarkPrimaryValue = 0xff5aaafb;

  static const ArcoColor arcoBlueDark =
      ArcoColor(_arcoBlueDarkPrimaryValue, <int, Color>{
    1: Color(0xff000d4d),
    2: Color(0xff041b79),
    3: Color(0xff0e32a6),
    4: Color(0xff1d4dd2),
    5: Color(0xff306eff),
    6: Color(_arcoBlueDarkPrimaryValue),
    7: Color(0xff689fff),
    8: Color(0xff93beff),
    9: Color(0xffbedaff),
    10: Color(0xffeaf4ff),
  });
  static const int _arcoBlueDarkPrimaryValue = 0xff3c7eff;

  static const ArcoColor purpleDark =
      ArcoColor(_purpleDarkPrimaryValue, <int, Color>{
    1: Color(0xff16004d),
    2: Color(0xff27066e),
    3: Color(0xff3e138f),
    4: Color(0xff5a25b0),
    5: Color(0xff7b3dd1),
    6: Color(_purpleDarkPrimaryValue),
    7: Color(0xffa974e3),
    8: Color(0xffc59aed),
    9: Color(0xffdfc2f6),
    10: Color(0xfff7edff),
  });
  static const int _purpleDarkPrimaryValue = 0xff8e51da;

  static const ArcoColor pinkPurpleDark =
      ArcoColor(_pinkPurpleDarkPrimaryValue, <int, Color>{
    1: Color(0xff42004d),
    2: Color(0xff650370),
    3: Color(0xff8a0d93),
    4: Color(0xffb01bb6),
    5: Color(0xffd92ed9),
    6: Color(_pinkPurpleDarkPrimaryValue),
    7: Color(0xffe866df),
    8: Color(0xfff092e6),
    9: Color(0xfff7c1f0),
    10: Color(0xfffff2fd),
  });
  static const int _pinkPurpleDarkPrimaryValue = 0xffe13ddb;

  static const ArcoColor magentaDark =
      ArcoColor(_magentaDarkPrimaryValue, <int, Color>{
    1: Color(0xff4d0034),
    2: Color(0xff770850),
    3: Color(0xffa1176c),
    4: Color(0xffcb2b88),
    5: Color(0xfff545a6),
    6: Color(_magentaDarkPrimaryValue),
    7: Color(0xfff97ab8),
    8: Color(0xfffb9ec8),
    9: Color(0xfffdc3db),
    10: Color(0xffffe8f1),
  });
  static const int _magentaDarkPrimaryValue = 0xfff756a9;

  static const ArcoColor grayDark =
      ArcoColor(_grayDarkPrimaryValue, <int, Color>{
    1: Color(0xff17171a),
    2: Color(0xff2e2e30),
    3: Color(0xff484849),
    4: Color(0xff5f5f60),
    5: Color(0xff78787a),
    6: Color(_grayDarkPrimaryValue),
    7: Color(0xffababac),
    8: Color(0xffc5c5c5),
    9: Color(0xffdfdfdf),
    10: Color(0xfff6f6f6),
  });
  static const int _grayDarkPrimaryValue = 0xff929293;
}

class ArcoColor extends ColorSwatch<int> {
  const ArcoColor(super.primary, super.swatch);

  Color get shade1 => this[1]!;

  Color get shade2 => this[2]!;

  Color get shade3 => this[3]!;

  Color get shade4 => this[4]!;

  Color get shade5 => this[5]!;

  /// default
  Color get shade6 => this[6]!;

  Color get shade7 => this[7]!;

  Color get shade8 => this[8]!;

  Color get shade9 => this[9]!;

  Color get shade10 => this[10]!;
}
