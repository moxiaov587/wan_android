part of 'common_provider.dart';

final StreamProvider<ConnectivityResult> connectivityStreamProvider =
    StreamProvider<ConnectivityResult>(
  (StreamProviderRef<ConnectivityResult> ref) {
    return Connectivity().onConnectivityChanged;
  },
);

@Riverpod(keepAlive: true)
class NetworkConnectivity extends _$NetworkConnectivity {
  bool get isDisconnected => state == ConnectivityResult.none;

  @override
  ConnectivityResult? build() {
    final ConnectivityResult? data = ref
        .watch(connectivityStreamProvider)
        .whenOrNull(data: (ConnectivityResult data) => data);

    if (data == ConnectivityResult.mobile) {
      DialogUtils.tips(S.current.useDataTrafficTips);
    }

    return data;
  }
}
