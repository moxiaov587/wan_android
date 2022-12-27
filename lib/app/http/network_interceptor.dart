import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderContainer;

import '../../screen/provider/connectivity_provider.dart';
import '../l10n/generated/l10n.dart';
import 'error_interceptor.dart';

class NetWorkInterceptor extends Interceptor {
  NetWorkInterceptor({required this.providerContainer});

  final ProviderContainer providerContainer;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (await providerContainer
        .read(connectivityProvider.notifier)
        .checkDisconnection()) {
      handler.reject(
        DioError(
          requestOptions: options,
          error: AppException(
            errorCode: -2,
            message: S.current.networkException,
          ),
        ),
      );

      return;
    }

    super.onRequest(options, handler);
  }
}
