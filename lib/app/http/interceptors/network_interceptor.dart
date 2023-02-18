part of 'interceptors.dart';

class NetWorkInterceptor extends Interceptor {
  NetWorkInterceptor({required this.ref});

  final Ref ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (ref.read(networkConnectivityProvider.notifier).isDisconnected) {
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
