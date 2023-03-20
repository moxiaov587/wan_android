import 'package:dio/dio.dart' show DioError, DioErrorType, Response;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../http/interceptors/interceptors.dart' show ResponseData;
import 'view_state.dart';

part 'base_list_view_notifier.dart';
part 'base_refresh_list_view_notifier.dart';

part 'provider.freezed.dart';

extension ViewErrorExtension on ViewError {
  String Function(String defaultMessage) get errorMessage =>
      (String defaultMessage) =>
          '${message ?? detail ?? defaultMessage}(${statusCode ?? -1})';
}

@freezed
class ViewError with _$ViewError implements Exception {
  const factory ViewError({
    int? statusCode,
    String? message,
    String? detail,
  }) = _ViewError;

  /// Define a private empty constructor to make custom methods work.
  const ViewError._();

  factory ViewError.networkException({
    String? message,
    String? detail,
  }) =>
      ViewError(
        statusCode: kNetworkExceptionStatusCode,
        message: message,
        detail: detail,
      );

  factory ViewError.fromResponseData(ResponseData data) => ViewError(
        statusCode: data.code,
        message: data.message,
      );

  factory ViewError.create(Object e, StackTrace? _) {
    int? statusCode;
    String? message;
    String? detail;

    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.connectionTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          // timeout
          statusCode = kTimeoutStatusCode;
          message = e.message;
          break;
        case DioErrorType.badCertificate:
        case DioErrorType.badResponse:
        case DioErrorType.connectionError:
          // incorrect status, such as 404, 503...
          final Response<dynamic>? response = e.response;
          if (response != null) {
            statusCode = response.statusCode;
          }
          message = e.message;
          break;
        case DioErrorType.cancel:
        case DioErrorType.unknown:
          if (e.type == DioErrorType.cancel) {
            statusCode = kCancelRequestStatusCode;
            message = e.message;
          }
          final dynamic error = e.error;
          if (error is ViewError) {
            return error;
          } else {
            message ??= e.message;
            detail = e.error?.toString();
          }
          break;
      }
    } else if (e is ViewError) {
      return e;
    } else {
      detail = e.toString();
    }

    return ViewError(
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
