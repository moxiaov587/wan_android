part of 'interceptors.dart';

class NetWorkInterceptor extends Interceptor {
  NetWorkInterceptor({required this.ref});

  final Ref ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (await ref.read(connectivityStreamProvider.future) ==
        ConnectivityResult.none) {
      // Add a random delay of 500 ms to 1000 ms to "comfort" the user.
      await Future<void>.delayed(
        Duration(milliseconds: Random().nextInt(500) + 500),
      );
      handler.reject(
        DioError(
          requestOptions: options,
          error: ViewError.networkException(
            message: S.current.networkException,
          ),
        ),
      );

      return;
    }

    super.onRequest(options, handler);
  }
}
