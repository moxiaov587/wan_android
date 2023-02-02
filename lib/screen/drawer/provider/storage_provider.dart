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

    return '${(this! / math.pow(1024, i)).toStringAsFixed(2)} ${_kFileSizeSuffixes[i]}';
  }
}

final AutoDisposeStateProvider<bool> checkOtherCachesProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => true,
);
final AutoDisposeStateProvider<bool> disableCheckOtherCachesProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => ref
      .watch(otherCacheSizeProvider)
      .maybeWhen((int? value) => (value ?? 0) <= 0, orElse: () => true),
);
final AutoDisposeStateProvider<bool> cleanableOtherCachesProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) =>
      ref.watch(checkOtherCachesProvider) &&
      !ref.watch(disableCheckOtherCachesProvider),
);

final AutoDisposeStateProvider<bool> checkResponseDataCachesProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => true,
);
final AutoDisposeStateProvider<bool> disableCheckResponseDataCachesProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => ref
      .watch(responseDataCacheSizeProvider)
      .maybeWhen((int? value) => (value ?? 0) <= 0, orElse: () => true),
);
final AutoDisposeStateProvider<bool> cleanableResponseDataCachesProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) =>
      ref.watch(checkResponseDataCachesProvider) &&
      !ref.watch(disableCheckResponseDataCachesProvider),
);

final AutoDisposeStateProvider<bool> checkPreferencesCachesProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => true,
);
final AutoDisposeStateProvider<bool> disableCheckPreferencesCachesProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => ref
      .watch(preferencesCacheSizeProvider)
      .maybeWhen((int? value) => (value ?? 0) <= 0, orElse: () => true),
);
final AutoDisposeStateProvider<bool> cleanablePreferencesCachesProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) =>
      ref.watch(checkPreferencesCachesProvider) &&
      !ref.watch(disableCheckPreferencesCachesProvider),
);

final AutoDisposeStateProvider<bool> checkAllCachesProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) =>
      ref.watch(checkOtherCachesProvider) &&
      ref.watch(checkResponseDataCachesProvider) &&
      ref.watch(checkPreferencesCachesProvider),
);
final AutoDisposeStateProvider<bool> cleanableProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) =>
      ref.watch(cleanableOtherCachesProvider) ||
      ref.watch(cleanableResponseDataCachesProvider) ||
      ref.watch(cleanablePreferencesCachesProvider),
);

final AutoDisposeStateNotifierProvider<OtherCacheSizeNotifier, ViewState<int>>
    otherCacheSizeProvider =
    StateNotifierProvider.autoDispose<OtherCacheSizeNotifier, ViewState<int>>(
  (_) {
    return OtherCacheSizeNotifier(
      const ViewState<int>.loading(),
    );
  },
);

class OtherCacheSizeNotifier extends BaseViewNotifier<int> {
  OtherCacheSizeNotifier(super.state);

  List<Future<void>> get clearTask => <Future<void>>[
        DatabaseManager.homeBannerCaches.clear(),
        DatabaseManager.searchHistoryCaches.clear(),
      ];

  @override
  Future<int> loadData() async {
    return (await Future.wait<int>(<Future<int>>[
      DatabaseManager.homeBannerCaches.getSize(),
      DatabaseManager.searchHistoryCaches.getSize(),
    ]))
        .reduce((int total, int size) => total += size);
  }
}

final AutoDisposeStateNotifierProvider<ResponseDataCacheSizeNotifier,
        ViewState<int>> responseDataCacheSizeProvider =
    StateNotifierProvider.autoDispose<ResponseDataCacheSizeNotifier,
        ViewState<int>>((_) {
  return ResponseDataCacheSizeNotifier(
    const ViewState<int>.loading(),
  );
});

class ResponseDataCacheSizeNotifier extends BaseViewNotifier<int> {
  ResponseDataCacheSizeNotifier(super.state);

  List<Future<void>> get clearTask => <Future<void>>[
        DatabaseManager.responseCaches.clear(),
      ];

  @override
  Future<int> loadData() {
    return DatabaseManager.responseCaches.getSize();
  }
}

final AutoDisposeStateNotifierProvider<PreferencesCacheSizeNotifier,
        ViewState<int>> preferencesCacheSizeProvider =
    StateNotifierProvider.autoDispose<PreferencesCacheSizeNotifier,
        ViewState<int>>((_) {
  return PreferencesCacheSizeNotifier(
    const ViewState<int>.loading(),
  );
});

class PreferencesCacheSizeNotifier extends BaseViewNotifier<int> {
  PreferencesCacheSizeNotifier(super.state);

  List<Future<void>> get clearTask => <Future<void>>[
        DatabaseManager.userSettingsCache.clear(),
      ];

  @override
  Future<int> loadData() {
    return DatabaseManager.userSettingsCache.getSize();
  }
}
