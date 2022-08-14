part of 'converters.dart';

class LocaleConverter extends TypeConverter<Locale?, String> {
  const LocaleConverter(); // Converters need to have an empty const constructor

  @override
  Locale? fromIsar(String object) {
    if (object.isEmpty) {
      return null;
    }

    final List<String> localeCodes = object.split('-');

    if (localeCodes.length == 1) {
      return Locale(localeCodes.first);
    } else if (localeCodes.length == 2) {
      return Locale(localeCodes.first, localeCodes.last);
    }

    return null;
  }

  @override
  String toIsar(Locale? object) {
    return object?.toLanguageTag() ?? '';
  }
}
