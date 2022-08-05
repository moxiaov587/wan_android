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
    final String uriString = options.uri.toString();

    if (options.needRefresh) {
      _onNeedRefresh(isDiskCache: options.isDiskCache, uriString: uriString);

      handler.next(options);

      return;
    } else if (options.needCache) {
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

      if (options.isDiskCache) {
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

    if (options.needCache) {
      final String uriString = options.uri.toString();

      final ResponseCache responseCache = ResponseCache(
        uri: uriString,
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        data: response.data,
      );
      if (options.isDiskCache) {
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

extension RequestOptionsExtension on RequestOptions {
  bool get needRefresh => extra[CacheOption.needRefresh.name] as bool? ?? false;

  bool get needCache =>
      method.toLowerCase() == _kMethodGetLowerCase &&
      (extra[CacheOption.needCache.name] as bool? ?? false);

  bool get isDiskCache => extra[CacheOption.isDiskCache.name] as bool? ?? false;
}
