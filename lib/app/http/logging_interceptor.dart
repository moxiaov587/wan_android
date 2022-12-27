import 'package:diox/diox.dart';
import '../../utils/log_utils.dart';

class LoggingInterceptor extends Interceptor {
  late DateTime startTime;
  late DateTime endTime;

  static const String HTTP_TAG = 'HTTP - LOG';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    startTime = DateTime.now();
    LogUtils.d(' ', tag: HTTP_TAG);
    LogUtils.d(
      '------------------- Start -------------------',
      tag: HTTP_TAG,
    );
    if (options.queryParameters.isEmpty) {
      LogUtils.d(
        'Request Url         : '
        '${options.method}'
        ' '
        '${options.baseUrl}'
        '${options.path}',
        tag: HTTP_TAG,
      );
    } else {
      LogUtils.d(
        'Request Url         : '
        '${options.method}  '
        '${options.baseUrl}${options.path}?'
        '${Transformer.urlEncodeMap(options.queryParameters)}',
        tag: HTTP_TAG,
      );
    }
    LogUtils.d(
      'Request ContentType : ${options.contentType}',
      tag: HTTP_TAG,
    );
    if (options.data != null) {
      LogUtils.d(
        'Request Data        : ${options.data.toString()}',
        tag: HTTP_TAG,
      );
    }
    LogUtils.d(
      'Request Headers     : ${options.headers.toString()}',
      tag: HTTP_TAG,
    );
    LogUtils.d('--', tag: HTTP_TAG);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    endTime = DateTime.now();
    final int duration = endTime.difference(startTime).inMilliseconds;
    LogUtils.d(
      'Response_Code       : ${response.statusCode}',
      tag: HTTP_TAG,
    );
    // 输出结果
    LogUtils.d(
      'Response_Data       : ${response.data.toString()}',
      tag: HTTP_TAG,
    );
    LogUtils.d(
      '------------- End: $duration ms -------------',
      tag: HTTP_TAG,
    );
    LogUtils.d('' '', tag: HTTP_TAG);
    handler.next(response);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    LogUtils.e(
      '------------------- Error -------------------',
      tag: HTTP_TAG,
    );
    handler.next(err);
  }
}
