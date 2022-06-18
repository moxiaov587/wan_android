import 'dart:io';

import 'package:dio/dio.dart';
import '../../utils/log_utils.dart';

class ErrorInterceptor extends Interceptor {
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
      throw AppException.fromResponseData(responseData);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.isRedirect ??
        false ||
            err.response?.statusCode == HttpStatus.movedPermanently ||
            err.response?.statusCode == HttpStatus.movedTemporarily ||
            err.response?.statusCode == HttpStatus.seeOther ||
            err.response?.statusCode == HttpStatus.temporaryRedirect) {
      handler.next(err);
    } else {
      if (err.response?.statusCode == 401) {
        LogUtils.e(
          'Session is outdated, calling updater...',
          withStackTrace: false,
        );
        // updateTicket();
      }
      LogUtils.e(
        'Error when requesting ${err.requestOptions.uri} '
        '${err.response?.statusCode}'
        ': ${err.response?.data}',
        withStackTrace: false,
      );
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
