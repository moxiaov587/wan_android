import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/hive_boxes.dart';
import '../../database/model/models.dart';

final StateNotifierProvider<ThemeNotifier, ThemeMode> themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((_) {
  final int? themeMode = HiveBoxes.uniqueUserSettings?.themeMode;

  return ThemeNotifier(ThemeNotifier.themeModes[themeMode] ?? ThemeMode.system);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(super.state);

  static const Map<int, ThemeMode> themeModes = <int, ThemeMode>{
    0: ThemeMode.system,
    1: ThemeMode.light,
    2: ThemeMode.dark,
  };

  void switchThemes(int index) {
    if (state == themeModes[index]) {
      return;
    }

    state = themeModes[index]!;

    if (HiveBoxes.uniqueUserSettings == null) {
      HiveBoxes.userSettingsBox.add(
        UserSettings(
          themeMode: index,
        ),
      );
    } else {
      HiveBoxes.userSettingsBox.putAt(
        0,
        HiveBoxes.uniqueUserSettings!.copyWith(
          themeMode: index,
        ),
      );
    }
  }
}
