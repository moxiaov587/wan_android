import 'package:hive/hive.dart';

import 'model/models.dart';

const String boxPrefix = 'app';

class HiveBoxes {
  const HiveBoxes._();

  static late Box<ResponseCache> responseCacheBox;

  static Future<void> openBoxes() async {
    Hive.registerAdapter(ResponseCacheAdapter());

    await Future.wait(
      <Future<void>>[
        () async {
          responseCacheBox = await Hive.openBox('${boxPrefix}_response_cache');
        }(),
      ],
    );
  }
}

class HiveAdapterTypeIds {
  const HiveAdapterTypeIds._();

  static const int responseCache = 0;
}
