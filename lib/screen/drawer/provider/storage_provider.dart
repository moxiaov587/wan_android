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

mixin CacheSizeProviderMixin on AutoDisposeNotifier<int> {
  @protected
  List<VoidCallback> getClearTxn();
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
      otherCacheSizeProvider.select((int value) => value <= 0),
    );

@Riverpod(dependencies: <Object>[disableCheckOtherCaches])
bool cleanableOtherCaches(CleanableOtherCachesRef ref) =>
    ref.watch(checkOtherCachesProvider) &&
    !ref.watch(disableCheckOtherCachesProvider);

@Riverpod(dependencies: <Object>[appDatabase])
class OtherCacheSize extends _$OtherCacheSize with CacheSizeProviderMixin {
  late Isar _isar;

  @override
  List<VoidCallback> getClearTxn() => <VoidCallback>[
        _isar.bannerCaches.clear,
        _isar.searchHistoryCaches.clear,
      ];

  @override
  int build() {
    _isar = ref.read(appDatabaseProvider);

    return <int>[
      _isar.bannerCaches.getSize(),
      _isar.searchHistoryCaches.getSize(),
    ].reduce((int total, int size) => total += size);
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
    ref.watch(responseDataCacheSizeProvider.select((int value) => value <= 0));

@Riverpod(dependencies: <Object>[disableCheckResponseDataCaches])
bool cleanableResponseDataCaches(CleanableResponseDataCachesRef ref) =>
    ref.watch(checkResponseDataCachesProvider) &&
    !ref.watch(disableCheckResponseDataCachesProvider);

@Riverpod(dependencies: <Object>[appDatabase])
class ResponseDataCacheSize extends _$ResponseDataCacheSize
    with CacheSizeProviderMixin {
  late Isar _isar;

  @override
  List<VoidCallback> getClearTxn() => <VoidCallback>[
        _isar.responseDataCaches.clear,
      ];

  @override
  int build() {
    _isar = ref.read(appDatabaseProvider);

    return _isar.responseDataCaches.getSize();
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
    ref.watch(preferencesCacheSizeProvider.select((int value) => value <= 0));

@Riverpod(dependencies: <Object>[disableCheckPreferencesCaches])
bool cleanablePreferencesCaches(CleanablePreferencesCachesRef ref) =>
    ref.watch(checkPreferencesCachesProvider) &&
    !ref.watch(disableCheckPreferencesCachesProvider);

@Riverpod(dependencies: <Object>[appDatabase])
class PreferencesCacheSize extends _$PreferencesCacheSize
    with CacheSizeProviderMixin {
  late Isar _isar;

  @override
  List<VoidCallback> getClearTxn() => <VoidCallback>[
        _isar.userSettingsCaches.clear,
      ];

  @override
  int build() {
    _isar = ref.read(appDatabaseProvider);

    return _isar.userSettingsCaches.getSize();
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
