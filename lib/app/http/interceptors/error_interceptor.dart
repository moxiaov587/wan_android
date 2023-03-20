part of 'interceptors.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({required this.ref});

  final Ref ref;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final ResponseData responseData =
        ResponseData.fromJson(response.data as Map<String, dynamic>);

    if (responseData.success) {
      response.data = responseData.data;
      handler.next(response);
    } else {
      handler.reject(
        DioError(
          requestOptions: response.requestOptions,
          error: ViewError.fromResponseData(responseData),
        ),
        true,
      );
    }
  }

  @override
  // ignore: long-method
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.isRedirect ??
        false ||
            err.response?.statusCode == HttpStatus.movedPermanently ||
            err.response?.statusCode == HttpStatus.movedTemporarily ||
            err.response?.statusCode == HttpStatus.seeOther ||
            err.response?.statusCode == HttpStatus.temporaryRedirect) {
      handler.next(err);
    } else {
      LogUtils.e(
        'Error when requesting ${err.requestOptions.uri} '
        '${err.response?.statusCode}'
        ': ${err.response?.data}',
        withStackTrace: false,
      );

      final dynamic error = err.error;
      if (error is ViewError) {
        if (error.isUnAuthorized) {
          LogUtils.e(
            'Session is outdated, calling updater...',
            withStackTrace: false,
          );

          final Isar isar = ref.read(appDatabaseProvider);

          final AccountCache? lastLoginAccount =
              isar.accountCaches.where().sortByUpdateTimeDesc().findFirstSync();

          if (lastLoginAccount != null && lastLoginAccount.password != null) {
            final bool result =
                await ref.read(authorizedProvider.notifier).silentLogin(
                      username: lastLoginAccount.username,
                      password: lastLoginAccount.password!,
                    );

            if (result) {
              // Retry once
              try {
                final Response<dynamic> response = await ref
                    .read(networkProvider)
                    .dio
                    .fetch<dynamic>(err.requestOptions);

                handler.resolve(response);
              } on Exception catch (_) {
                handler.reject(
                  DioError(
                    requestOptions: err.requestOptions,
                    error: error,
                  ),
                );
              }

              return;
            }
          }
        }
      }

      handler.reject(err);
    }
  }
}

@freezed
class ResponseData with _$ResponseData {
  factory ResponseData({
    @Default(0) int code,
    String? message,
    dynamic data,
  }) = _ResponseData;

  const ResponseData._();

  factory ResponseData.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataFromJson(json);

  bool get success => code == 0;
}
