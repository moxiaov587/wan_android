import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:riverpod/riverpod.dart';

import '../../app/provider/provider.dart';
import '../../app/provider/view_state.dart';

final StateNotifierProvider<ConnectivityNotifier, ViewState<ConnectivityResult>>
    connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ViewState<ConnectivityResult>>(
        (_) {
  return ConnectivityNotifier();
});

class ConnectivityNotifier extends BaseViewNotifier<ConnectivityResult> {
  ConnectivityNotifier() : super(const ViewState<ConnectivityResult>.loading());

  final Connectivity _connectivity = Connectivity();

  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  bool get isDisconnected =>
      state.whenOrNull(
          (ConnectivityResult? result) => result == ConnectivityResult.none) ??
      false;

  @override
  Future<ConnectivityResult?> loadData() async {
    try {
      return await _connectivity.checkConnectivity();
    } on PlatformException {
      rethrow;
    }
  }

  Future<void> updateData(ConnectivityResult result) async {
    state = ViewStateData<ConnectivityResult>(value: result);
  }
}
