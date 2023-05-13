import 'dart:ui' as ui;

import 'package:flutter/material.dart' show kToolbarHeight;
import 'package:flutter/widgets.dart' show MediaQueryData;

class ScreenUtils {
  const ScreenUtils._();

  static MediaQueryData get mediaQuery => MediaQueryData.fromView(
        ui.PlatformDispatcher.instance.views.first,
      );

  static double fixedFontSize(double fontSize) => fontSize / textScaleFactor;

  static double get scale => mediaQuery.devicePixelRatio;

  static double get width => mediaQuery.size.width;

  static int get widthPixels => (width * scale).toInt();

  static double get height => mediaQuery.size.height;

  static int get heightPixels => (height * scale).toInt();

  static double get aspectRatio => width / height;

  static double get textScaleFactor => mediaQuery.textScaleFactor;

  static double get navigationBarHeight =>
      mediaQuery.padding.top + kToolbarHeight;

  static double get topSafeHeight => mediaQuery.padding.top;

  static double get bottomSafeHeight => mediaQuery.padding.bottom;

  static double get safeHeight => height - topSafeHeight - bottomSafeHeight;
}
