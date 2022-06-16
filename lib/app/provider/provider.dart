import 'package:dio/dio.dart' show DioError, DioErrorType, Response;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../http/error_interceptor.dart' show AppException;
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
      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          // timeout
          statusCode = -1;
          break;
        case DioErrorType.response:
          // incorrect status, such as 404, 503...
          final Response<dynamic>? response = e.response;
          if (response != null) {
            statusCode = response.statusCode;
          }
          break;
        case DioErrorType.cancel:
          // TODO:
          break;
        case DioErrorType.other:
          // TODO:
          break;
      }
    } else if (e is AppException) {
      statusCode = e.errorCode;
      message = e.message;
      detail = e.detail;
    } else {
      detail = e.toString();
    }

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
