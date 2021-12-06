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

const String _kMethodGetLowerCase = 'get';

enum CacheOption {
  needRefresh,
  needCache,
  isDiskCache,
}

class CacheInterceptors extends Interceptor {
  final LinkedHashMap<String, ResponseCache> _cache =
      LinkedHashMap<String, ResponseCache>();

  bool _needRefresh(RequestOptions options) =>
      options.extra[CacheOption.needRefresh.name] as bool? ?? false;

  bool _needCache(RequestOptions options) =>
      (options.extra[CacheOption.needCache.name] as bool? ?? false) &&
      options.method.toLowerCase() == _kMethodGetLowerCase;

  bool _isDiskCache(RequestOptions options) =>
      options.extra[CacheOption.isDiskCache.name] as bool? ?? false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final bool isDiskCache = _isDiskCache(options);

    final String key = options.uri.toString();

    if (_needRefresh(options)) {
      if (isDiskCache) {
        HiveBoxes.responseCacheBox.delete(key);
      } else {
        _cache.remove(key);
      }

      handler.next(options);

      return;
    } else if (_needCache(options)) {
      final ResponseCache? response = _cache[key];

      if (response != null) {
        if ((DateTime.now().millisecondsSinceEpoch - response.timeStamp) /
                1000 <
            _kCacheMaxAge) {
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: response.data,
            ),
          );

          return;
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
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: responseCache?.data,
            ),
          );

          return;
        } else {
          HiveBoxes.responseCacheBox.delete(key);
        }
      }
    }

    handler.next(options);
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
      if (_isDiskCache(options)) {
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
  }
}
