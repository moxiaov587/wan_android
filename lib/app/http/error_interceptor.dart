import 'dart:io';

import 'package:diox/diox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database_manager.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import '../../utils/log_utils.dart';
import 'http.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({required this.providerContainer});

  final ProviderContainer providerContainer;

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
      if (error is AppException) {
        if (error.isUnAuthorized) {
          LogUtils.e(
            'Session is outdated, calling updater...',
            withStackTrace: false,
          );

          final AccountCache? lastLoginAccount = DatabaseManager.accountCaches
              .where()
              .sortByUpdateTimeDesc()
              .findFirstSync();

          if (lastLoginAccount != null && lastLoginAccount.password != null) {
            final bool result = await providerContainer
                .read(authorizedProvider.notifier)
                .silentLogin(
                  username: lastLoginAccount.username,
                  password: lastLoginAccount.password!,
                );

            if (result) {
              // Retry once
              try {
                final Response<dynamic> response =
                    await Http.dio.fetch<dynamic>(err.requestOptions);

                handler.resolve(response);
              } catch (_) {
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

class ResponseData {
  ResponseData({
    this.code = 0,
    this.message,
    this.data,
  });

  ResponseData.fromJson(Map<String, dynamic> json)
      : code = json['errorCode'] as int,
        message = json['errorMsg'] as String,
        data = json['data'];

  int code;
  String? message;
  dynamic data;

  bool get success => code == 0;
}

class AppException implements Exception {
  AppException({
    this.errorCode,
    this.message,
    this.detail,
  });

  AppException.fromResponseData(ResponseData data)
      : errorCode = data.code,
        message = data.message;

  int? errorCode;
  String? message;
  String? detail;

  bool get isUnAuthorized => errorCode == -1001;

  @override
  String toString() =>
      '$runtimeType(${errorCode ?? -1}) ${message ?? 'unknown error'} ${detail ?? 'no more info.'}';
}
