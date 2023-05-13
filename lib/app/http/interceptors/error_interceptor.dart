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
          error: AppException.fromResponseData(responseData),
        ),
        true,
      );
    }
  }

  @override
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
      if (error is AppException) {
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

extension AppExceptionExtension on AppException {
  String Function(String defaultMessage) get errorMessage =>
      (String defaultMessage) =>
          '${message ?? detail ?? defaultMessage}(${statusCode ?? -1})';
}

@freezed
class AppException with _$AppException implements Exception {
  const factory AppException({
    int? statusCode,
    String? message,
    String? detail,
  }) = _AppException;

  /// Define a private empty constructor to make custom methods work.
  const AppException._();

  factory AppException.networkException({
    String? message,
    String? detail,
  }) =>
      AppException(
        statusCode: kNetworkExceptionStatusCode,
        message: message,
        detail: detail,
      );

  factory AppException.fromResponseData(ResponseData data) => AppException(
        statusCode: data.code,
        message: data.message,
      );

  factory AppException.create(Object e, StackTrace? _) {
    int? statusCode;
    String? message;
    String? detail;

    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.connectionTimeout ||
              DioErrorType.sendTimeout ||
              DioErrorType.receiveTimeout:
          // timeout
          statusCode = kTimeoutStatusCode;
          message = e.message;
        case DioErrorType.badCertificate ||
              DioErrorType.badResponse ||
              DioErrorType.connectionError:
          // incorrect status, such as 404, 503...
          final Response<dynamic>? response = e.response;
          if (response != null) {
            statusCode = response.statusCode;
          }
          message = e.message;
        case DioErrorType.cancel || DioErrorType.unknown:
          if (e.type == DioErrorType.cancel) {
            statusCode = kCancelRequestStatusCode;
            message = e.message;
          }
          final dynamic error = e.error;
          if (error is AppException) {
            return error;
          } else {
            message ??= e.message;
            detail = e.error?.toString();
          }
      }
    } else if (e is AppException) {
      return e;
    } else {
      detail = e.toString();
    }

    return AppException(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }

  bool get isUnAuthorized => statusCode == kUnAuthorizedStatusCode;

  bool get isNetworkException => statusCode == kNetworkExceptionStatusCode;
}

const int kUnAuthorizedStatusCode = -1001;
const int kTimeoutStatusCode = -1;
const int kNetworkExceptionStatusCode = -2;
const int kCancelRequestStatusCode = -3;
