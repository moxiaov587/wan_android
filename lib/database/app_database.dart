import 'dart:io';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../screen/provider/common_provider.dart' show Language;
import 'model/models.dart';

export 'package:isar/isar.dart';
export 'model/models.dart';

part 'isar_extension.dart';
part 'app_database.g.dart';

@Riverpod(keepAlive: true)
external Isar appDatabase();

Future<Isar> openIsar() async {
  final Directory dir = await getApplicationSupportDirectory();

  return Isar.open(
    <CollectionSchema<dynamic>>[
      AccountCacheSchema,
      HomeBannerCacheSchema,
      ResponseCacheSchema,
      SearchHistorySchema,
      UserSettingsSchema,
    ],
    directory: dir.path,
  );
}
