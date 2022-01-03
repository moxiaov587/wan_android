import 'package:dio/dio.dart' show DioError, DioErrorType, Response;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/http/error_interceptors.dart' show AppException;
import 'view_state.dart';

part 'base_list_view_notifier.dart';
part 'base_refresh_list_view_notifier.dart';
part 'base_view_notifier.dart';

class BaseViewStateError {
  BaseViewStateError({
    int? statusCode,
    String? message,
    String? detail,
  })  : _statusCode = statusCode,
        _message = message,
        _detail = detail;

  factory BaseViewStateError.create(Object e, StackTrace? _) {
    int? statusCode;
    String? message;
    String? detail;

    if (e is DioError) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        // timeout
        statusCode = -1;
      } else if (e.type == DioErrorType.response) {
        // incorrect status, such as 404, 503...
        final Response<dynamic>? response = e.response;
        if (response != null) {
          statusCode = response.statusCode;
        }
      } else if (e.type == DioErrorType.cancel) {
        // to be continue...
      }
    } else if (e is AppException) {
      statusCode = e.errorCode;
      message = e.message;
    }
    // else if (e is CustomError) {
    //   errorType = AppErrorType.custom;
    //   message = e.error;
    // }

    return BaseViewStateError(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }

  int? _statusCode;
  int? get statusCode => _statusCode;

  String? _message;
  String? get message => _message;

  String? _detail;
  String? get detail => _detail;
}
