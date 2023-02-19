import 'package:dio/dio.dart' show DioError, DioErrorType, Response;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../http/interceptors/interceptors.dart' show AppException;
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
class ViewError with _$ViewError {
  const factory ViewError({
    int? statusCode,
    String? message,
    String? detail,
  }) = _ViewError;

  /// Define a private empty constructor to make custom methods work.
  const ViewError._();

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
          statusCode = -1;
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
            statusCode = -3;
            message = e.message;
          }
          final dynamic error = e.error;
          if (error is AppException) {
            statusCode = error.errorCode;
            message = error.message;
            detail = error.detail;
          } else {
            message ??= e.message;
            detail = e.error?.toString();
          }
          break;
      }
    } else if (e is AppException) {
      statusCode = e.errorCode;
      message = e.message;
      detail = e.detail;
    } else {
      detail = e.toString();
    }

    return ViewError(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }
}
