import 'dart:collection' show LinkedHashMap;
import 'dart:convert' show jsonEncode, jsonDecode;
import 'package:diox/diox.dart'
    show
        Interceptor,
        RequestOptions,
        RequestInterceptorHandler,
        Response,
        ResponseInterceptorHandler;

import '../../database/database_manager.dart';

const Duration _kMaxAgeOfCache = Duration(hours: 12);
const int _kMaxNumOfCacheForMemory = 10;

const String _kGetMethodLowerCase = 'get';

class CacheInterceptor extends Interceptor {
  final LinkedHashMap<String, ResponseCache> _cache =
      LinkedHashMap<String, ResponseCache>();

  @override
  // ignore: long-method
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final String uriString = options.uri.toString();

    if (options.needRefresh) {
      if (options.isDiskCache) {
        DatabaseManager.isar.writeTxnSync(() {
          final int? id = DatabaseManager.responseCaches
              .filter()
              .uriEqualTo(uriString)
              .idProperty()
              .findFirstSync();

          if (id != null) {
            DatabaseManager.responseCaches.delete(id);
          }
        });
      } else {
        _cache.remove(uriString);
      }

      handler.next(options);

      return;
    } else if (options.needCache) {
      final ResponseCache? responseCacheForMemory = _cache[uriString];

      if (responseCacheForMemory != null) {
        if (DateTime.now().isBefore(responseCacheForMemory.expires)) {
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: jsonDecode(responseCacheForMemory.data),
            ),
          );

          return;
        } else {
          _cache.remove(uriString);
        }
      }

      final Query<ResponseCache> queryBuilder =
          DatabaseManager.responseCaches.filter().uriEqualTo(uriString).build();

      if (options.isDiskCache) {
        final ResponseCache? responseCacheForDisk =
            queryBuilder.findFirstSync();

        if (responseCacheForDisk != null &&
            DateTime.now().isBefore(responseCacheForDisk.expires)) {
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: jsonDecode(responseCacheForDisk.data),
            ),
          );

          return;
        } else {
          DatabaseManager.isar.writeTxnSync(
            () => queryBuilder.deleteFirstSync(),
          );
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

      final ResponseCache responseCache = ResponseCache()
        ..uri = uriString
        ..expires = DateTime.now().add(_kMaxAgeOfCache)
        ..data = jsonEncode(response.data);

      if (options.isDiskCache) {
        DatabaseManager.isar.writeTxnSync(
          () => DatabaseManager.responseCaches.putSync(responseCache),
        );
      } else {
        if (_cache.length == _kMaxNumOfCacheForMemory) {
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
      method.toLowerCase() == _kGetMethodLowerCase &&
      (extra[CacheOption.needCache.name] as bool? ?? false);

  bool get isDiskCache => extra[CacheOption.isDiskCache.name] as bool? ?? false;
}
