part of 'interceptors.dart';

class NetWorkInterceptor extends Interceptor {
  NetWorkInterceptor({required this.ref});

  final Ref ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (ref.read(connectivityStreamProvider).whenOrNull(
              data: (ConnectivityResult value) =>
                  value == ConnectivityResult.none,
            ) ??
        false) {
      // Add a random delay of 500 ms to 1000 ms to "comfort" the user.
      await Future<void>.delayed(
        Duration(milliseconds: Random().nextInt(500) + 500),
      );
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
