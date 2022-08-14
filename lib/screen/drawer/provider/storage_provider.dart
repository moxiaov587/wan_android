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

final AutoDisposeStateNotifierProvider<ApplicationCacheSizeNotifier,
        ViewState<int>> applicationCacheSizeProvider =
    StateNotifierProvider.autoDispose<ApplicationCacheSizeNotifier,
        ViewState<int>>((_) {
  return ApplicationCacheSizeNotifier(
    const ViewState<int>.loading(),
  );
});

class ApplicationCacheSizeNotifier extends BaseViewNotifier<int> {
  ApplicationCacheSizeNotifier(super.state);

  @override
  Future<int> loadData() async {
    return (await Future.wait<int>(<Future<int>>[
      DatabaseManager.responseCaches.getSize(),
      DatabaseManager.searchHistoryCaches.getSize(),
    ]))
        .reduce((int total, int size) => total += size);
  }

  Future<void> clear() async {
    await DatabaseManager.isar.writeTxn(
      () => Future.wait<void>(
        <Future<void>>[
          DatabaseManager.responseCaches.clear(),
          DatabaseManager.searchHistoryCaches.clear(),
        ],
      ),
    );

    initData();
  }
}
