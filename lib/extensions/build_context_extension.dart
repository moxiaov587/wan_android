part of 'extensions.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  bool get isDarkTheme => theme.brightness == Brightness.dark;

  Size get mqSize => MediaQuery.sizeOf(this);

  EdgeInsets get mqPadding => MediaQuery.paddingOf(this);

  TextScaler get mqTextScaler => MediaQuery.textScalerOf(this);
}
