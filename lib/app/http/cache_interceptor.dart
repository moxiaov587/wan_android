import 'dart:collection' show LinkedHashMap;
import 'package:collection/collection.dart';
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

class CacheInterceptor extends Interceptor {
  final LinkedHashMap<String, ResponseCache> _cache =
      LinkedHashMap<String, ResponseCache>();

  bool _needRefresh(RequestOptions options) =>
      options.extra[CacheOption.needRefresh.name] as bool? ?? false;

  bool _needCache(RequestOptions options) =>
      (options.extra[CacheOption.needCache.name] as bool? ?? false) &&
      options.method.toLowerCase() == _kMethodGetLowerCase;

  bool _isDiskCache(RequestOptions options) =>
      options.extra[CacheOption.isDiskCache.name] as bool? ?? false;

  dynamic _diskCacheKey(String uri) => HiveBoxes.responseCacheBox.values
      .firstWhereOrNull((ResponseCache element) => element.uri == uri)
      ?.key;

  void _onNeedRefresh({
    required bool isDiskCache,
    required String uriString,
  }) {
    if (isDiskCache) {
      final dynamic key = _diskCacheKey(uriString);

      if (key != null) {
        HiveBoxes.responseCacheBox.delete(key);
      }
    } else {
      _cache.remove(uriString);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final bool isDiskCache = _isDiskCache(options);

    final String uriString = options.uri.toString();

    if (_needRefresh(options)) {
      _onNeedRefresh(isDiskCache: isDiskCache, uriString: uriString);

      handler.next(options);

      return;
    } else if (_needCache(options)) {
      final ResponseCache? response = _cache[uriString];

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
          _cache.remove(uriString);
        }
      }

      if (isDiskCache) {
        final dynamic key = _diskCacheKey(uriString);

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
          if (key != null) {
            HiveBoxes.responseCacheBox.delete(key);
          }
        }
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final RequestOptions options = response.requestOptions;

    if (_needCache(options)) {
      final String uriString = options.uri.toString();

      final ResponseCache responseCache = ResponseCache(
        uri: uriString,
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        data: response.data,
      );
      if (_isDiskCache(options)) {
        HiveBoxes.responseCacheBox.add(responseCache);
      } else {
        if (_cache.length == _kCacheMaxCount) {
          _cache.remove(_cache.keys.first);
        }

        _cache[uriString] = responseCache;
      }
    }

    handler.next(response);
  }
}

enum CacheOption {
  needRefresh,
  needCache,
  isDiskCache,
}
