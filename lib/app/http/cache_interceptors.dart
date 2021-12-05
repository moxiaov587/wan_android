import 'dart:collection' show LinkedHashMap;

import 'package:dio/dio.dart'
    show
        Interceptor,
        RequestOptions,
        RequestInterceptorHandler,
        Response,
        ResponseInterceptorHandler;

import '../../database/hive_boxes.dart' show HiveBoxes;
import '../../database/model/models.dart' show ResponseCache;

const int _kCacheMaxAge = 60000;
const int _kCacheMaxCount = 10;

class CacheInterceptors extends Interceptor {
  final LinkedHashMap<String, ResponseCache> _cache =
      LinkedHashMap<String, ResponseCache>();

  bool _needRefresh(RequestOptions options) =>
      options.extra['isDiskCache'] as bool? ?? false;

  bool _needCache(RequestOptions options) =>
      (options.extra['cache'] as bool? ?? false) &&
      options.method.toLowerCase() == 'get';

  bool _needDiskCache(RequestOptions options) =>
      options.extra['isDiskCache'] as bool? ?? false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final bool isDiskCache = _needDiskCache(options);

    final String key = options.uri.toString();

    if (_needRefresh(options)) {
      if (isDiskCache) {
        HiveBoxes.responseCacheBox.delete(key);
      } else {
        _cache.remove(key);
      }

      return handler.next(options);
    } else if (_needCache(options)) {
      final ResponseCache? response = _cache[key];

      if (response != null) {
        if ((DateTime.now().millisecondsSinceEpoch - response.timeStamp) /
                1000 <
            _kCacheMaxAge) {
          return handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: response.data,
            ),
          );
        } else {
          _cache.remove(key);
        }
      }

      if (isDiskCache) {
        final ResponseCache? responseCache =
            HiveBoxes.responseCacheBox.get(key);

        if ((DateTime.now().millisecondsSinceEpoch -
                    (responseCache?.timeStamp ?? 0)) /
                1000 <
            _kCacheMaxAge) {
          return handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: responseCache?.data,
            ),
          );
        } else {
          HiveBoxes.responseCacheBox.delete(key);
        }
      }
    }

    handler.next(options);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    final RequestOptions options = response.requestOptions;

    if (_needCache(options)) {
      final String key = options.uri.toString();

      final ResponseCache responseCache = ResponseCache(
        uri: key,
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        data: response.data,
      );
      if (_needDiskCache(options)) {
        HiveBoxes.responseCacheBox.put(
          key,
          responseCache,
        );
      } else {
        if (_cache.length == _kCacheMaxCount) {
          _cache.remove(_cache.keys.first);
        }

        _cache[key] = responseCache;
      }
    }

    handler.next(response);

    super.onResponse(response, handler);
  }
}
