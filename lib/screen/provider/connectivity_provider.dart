part of 'common_provider.dart';

final StreamProvider<ConnectivityResult> connectivityStreamProvider =
    StreamProvider<ConnectivityResult>(
  (StreamProviderRef<ConnectivityResult> ref) async* {
    await for (final ConnectivityResult result
        in Connectivity().onConnectivityChanged) {
      if (result == ConnectivityResult.mobile) {
        DialogUtils.tips(S.current.useDataTrafficTips);
      }

      yield result;
    }
  },
);
