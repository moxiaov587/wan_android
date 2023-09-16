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
  void clearTxn(Isar isar);
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
  void clearTxn(Isar isar) {
    isar.bannerCaches.clear();
    isar.searchHistoryCaches.clear();
  }

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
  void clearTxn(Isar isar) {
    isar.responseDataCaches.clear();
  }

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
  void clearTxn(Isar isar) {
    isar.userSettingsCaches.clear();
  }

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

typedef CleanableState = ({bool other, bool responseData, bool preferences});

@Riverpod(
  dependencies: <Object>[
    appDatabase,
    cleanableOtherCaches,
    cleanableResponseDataCaches,
    cleanablePreferencesCaches,
    OtherCacheSize,
    ResponseDataCacheSize,
    PreferencesCacheSize,
  ],
)
class Cleanable extends _$Cleanable {
  @override
  CleanableState build() => (
        other: ref.watch(cleanableOtherCachesProvider),
        responseData: ref.watch(cleanableResponseDataCachesProvider),
        preferences: ref.watch(cleanablePreferencesCachesProvider),
      );

  void clear() {
    final bool cacheForPreferences = state.preferences;

    ref.read(appDatabaseProvider).write(
      (Isar isar) {
        if (state.other) {
          ref.read(otherCacheSizeProvider.notifier).clearTxn(isar);
        }
        if (state.responseData) {
          ref.read(responseDataCacheSizeProvider.notifier).clearTxn(isar);
        }
        if (state.preferences) {
          ref.read(preferencesCacheSizeProvider.notifier).clearTxn(isar);
        }
      },
    );

    ref
      ..invalidate(otherCacheSizeProvider)
      ..invalidate(responseDataCacheSizeProvider)
      ..invalidate(preferencesCacheSizeProvider);

    if (cacheForPreferences) {
      ref.invalidate(userSettingsProvider);
    }
  }
}
