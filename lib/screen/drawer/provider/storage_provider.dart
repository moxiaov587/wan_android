part of 'drawer_provider.dart';

const List<String> _kFileSizeSuffixes = <String>[
  'B',
  'KB',
  'MB',
  'GB',
  'TB',
  'PB',
  'EB',
  'ZB',
  'YB',
];

extension FileSizeExtension on int? {
  String get fileSize {
    if (this == null || this! <= 0) {
      return '0 B';
    }

    final int i = (math.log(this!) / math.log(1024)).floor();

    return '${(this! / math.pow(1024, i)).toStringAsFixed(2)} '
        '${_kFileSizeSuffixes[i]}';
  }
}

mixin CacheSizeProviderMixin on AutoDisposeAsyncNotifier<int> {
  @protected
  List<AsyncCallback> get clearTask;
}

// OtherCaches START
@riverpod
class CheckOtherCaches extends _$CheckOtherCaches
    with AutoDisposeNotifierUpdateMixin<bool> {
  @override
  bool build() => true;
}

@Riverpod(dependencies: <Object>[OtherCacheSize])
bool disableCheckOtherCaches(DisableCheckOtherCachesRef ref) => ref.watch(
      otherCacheSizeProvider.select(
        (AsyncValue<int> value) =>
            value.whenOrNull(data: (int data) => data <= 0) ?? true,
      ),
    );

@Riverpod(dependencies: <Object>[disableCheckOtherCaches])
bool cleanableOtherCaches(CleanableOtherCachesRef ref) =>
    ref.watch(checkOtherCachesProvider) &&
    !ref.watch(disableCheckOtherCachesProvider);

@Riverpod(dependencies: <Object>[appDatabase])
class OtherCacheSize extends _$OtherCacheSize with CacheSizeProviderMixin {
  late Isar isar;

  @override
  List<AsyncCallback> get clearTask => <AsyncCallback>[
        isar.homeBannerCaches.clear,
        isar.searchHistoryCaches.clear,
      ];

  @override
  Future<int> build() async {
    isar = ref.read(appDatabaseProvider);

    return (await Future.wait<int>(<Future<int>>[
      isar.homeBannerCaches.getSize(),
      isar.searchHistoryCaches.getSize(),
    ]))
        .reduce((int total, int size) => total += size);
  }
}
// OtherCaches END

// ResponseDataCaches START
@riverpod
class CheckResponseDataCaches extends _$CheckResponseDataCaches
    with AutoDisposeNotifierUpdateMixin<bool> {
  @override
  bool build() => true;
}

@Riverpod(dependencies: <Object>[ResponseDataCacheSize])
bool disableCheckResponseDataCaches(DisableCheckResponseDataCachesRef ref) =>
    ref.watch(
      responseDataCacheSizeProvider.select(
        (AsyncValue<int> value) =>
            value.whenOrNull(data: (int data) => data <= 0) ?? true,
      ),
    );

@Riverpod(dependencies: <Object>[disableCheckResponseDataCaches])
bool cleanableResponseDataCaches(CleanableResponseDataCachesRef ref) =>
    ref.watch(checkResponseDataCachesProvider) &&
    !ref.watch(disableCheckResponseDataCachesProvider);

@Riverpod(dependencies: <Object>[appDatabase])
class ResponseDataCacheSize extends _$ResponseDataCacheSize
    with CacheSizeProviderMixin {
  late Isar isar;

  @override
  List<AsyncCallback> get clearTask => <AsyncCallback>[
        isar.responseCaches.clear,
      ];

  @override
  Future<int> build() {
    isar = ref.read(appDatabaseProvider);

    return isar.responseCaches.getSize();
  }
}
// ResponseDataCaches END

// PreferencesCaches START
@riverpod
class CheckPreferencesCaches extends _$CheckPreferencesCaches
    with AutoDisposeNotifierUpdateMixin<bool> {
  @override
  bool build() => true;
}

@Riverpod(dependencies: <Object>[PreferencesCacheSize])
bool disableCheckPreferencesCaches(DisableCheckPreferencesCachesRef ref) =>
    ref.watch(
      preferencesCacheSizeProvider.select(
        (AsyncValue<int> value) =>
            value.whenOrNull(data: (int data) => data <= 0) ?? true,
      ),
    );

@Riverpod(dependencies: <Object>[disableCheckPreferencesCaches])
bool cleanablePreferencesCaches(CleanablePreferencesCachesRef ref) =>
    ref.watch(checkPreferencesCachesProvider) &&
    !ref.watch(disableCheckPreferencesCachesProvider);

@Riverpod(dependencies: <Object>[appDatabase])
class PreferencesCacheSize extends _$PreferencesCacheSize
    with CacheSizeProviderMixin {
  late Isar isar;

  @override
  List<AsyncCallback> get clearTask => <AsyncCallback>[
        isar.userSettingsCache.clear,
      ];

  @override
  Future<int> build() {
    isar = ref.read(appDatabaseProvider);

    return isar.userSettingsCache.getSize();
  }
}
// PreferencesCaches END

@riverpod
bool checkAllCaches(CheckAllCachesRef ref) =>
    ref.watch(checkOtherCachesProvider) &&
    ref.watch(checkResponseDataCachesProvider) &&
    ref.watch(checkPreferencesCachesProvider);

@Riverpod(
  dependencies: <Object>[
    cleanableOtherCaches,
    cleanableResponseDataCaches,
    cleanablePreferencesCaches,
  ],
)
bool cleanable(CleanableRef ref) =>
    ref.watch(cleanableOtherCachesProvider) ||
    ref.watch(cleanableResponseDataCachesProvider) ||
    ref.watch(cleanablePreferencesCachesProvider);
