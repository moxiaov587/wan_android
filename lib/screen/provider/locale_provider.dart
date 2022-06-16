import 'package:flutter/material.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/hive_boxes.dart';
import '../../database/model/models.dart';

final StateNotifierProvider<LocaleNotifier, Locale?> localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale?>((_) {
  final String? languages = HiveBoxes.uniqueUserSettings?.languages;

  return LocaleNotifier(LocaleNotifier.languagesToLocale(languages ?? ''));
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier(super.state);

  static const List<String> localeList = <String>['', 'en', 'zh_CN'];

  static Locale? languagesToLocale(String languages) {
    final List<String> locale = languages.split('_');
    if (locale.isNotEmpty && locale.first.isNotEmpty) {
      return Locale(locale.first, locale.last);
    }

    return null;
  }

  void switchLocale(String languages) {
    if (!localeList.contains(languages)) {
      return;
    }

    state = languagesToLocale(languages);

    if (HiveBoxes.uniqueUserSettings == null) {
      HiveBoxes.userSettingsBox.add(
        UserSettings(
          languages: languages,
        ),
      );
    } else {
      HiveBoxes.userSettingsBox.putAt(
        0,
        HiveBoxes.uniqueUserSettings!.copyWith(
          languages: languages,
        ),
      );
    }
  }
}
