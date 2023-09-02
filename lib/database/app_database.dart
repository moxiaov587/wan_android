import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'model/models.dart';

export 'package:isar/isar.dart';
export 'model/models.dart';

part 'app_database.g.dart';

@Riverpod(keepAlive: true)
external Isar appDatabase();

Future<Isar> openIsar() async {
  final Directory dir = await getApplicationSupportDirectory();

  return Isar.open(
    schemas: <IsarGeneratedSchema>[
      AccountCacheSchema,
      BannerCacheSchema,
      ResponseDataCacheSchema,
      SearchHistoryCacheSchema,
      UserSettingsCacheSchema,
    ],
    directory: dir.path,
  );
}
