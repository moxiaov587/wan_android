part of 'converters.dart';

class ThemeModeConverter extends TypeConverter<ThemeMode?, int> {
  const ThemeModeConverter(); // Converters need to have an empty const constructor

  @override
  ThemeMode? fromIsar(int object) {
    return ThemeMode.values[object];
  }

  @override
  int toIsar(ThemeMode? object) {
    return object?.index ?? ThemeMode.system.index;
  }
}
