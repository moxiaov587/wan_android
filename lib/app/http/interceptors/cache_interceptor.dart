part of 'interceptors.dart';

const Duration _kMaxAgeOfCache = Duration(hours: 12);
const int _kMaxNumOfCacheForMemory = 10;

const String _kGetMethodLowerCase = 'get';

class CacheInterceptor extends Interceptor {
  CacheInterceptor({required this.ref});

  final Ref ref;

  final LinkedHashMap<String, ResponseDataCache> _cache =
      LinkedHashMap<String, ResponseDataCache>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final String uriString = options.uri.toString();

    final IsarQuery<ResponseDataCache> queryBuilder = ref
        .read(appDatabaseProvider)
        .responseDataCaches
        .where()
        .uriEqualTo(uriString)
        .build();

    if (options.needRefresh) {
      if (options.isDiskCache) {
        ref.read(appDatabaseProvider).write<void>((Isar isar) {
          if (queryBuilder.count() > 0) {
            isar.responseDataCaches.delete(uriString);
          }
        });
      } else {
        _cache.remove(uriString);
      }

      handler.next(options);

      return;
    } else if (options.needCache) {
      final ResponseDataCache? responseCacheForMemory = _cache[uriString];

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

      if (options.isDiskCache) {
        final ResponseDataCache? responseCacheForDisk =
            queryBuilder.findFirst();

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
          ref.read(appDatabaseProvider).write(
                (Isar isar) => isar.responseDataCaches
                    .where()
                    .uriEqualTo(uriString)
                    .deleteFirst(),
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

      final ResponseDataCache responseCache = ResponseDataCache(
        uri: uriString,
        expires: DateTime.now().add(_kMaxAgeOfCache),
        data: jsonEncode(response.data),
      );

      if (options.isDiskCache) {
        ref.read(appDatabaseProvider).write(
              (Isar isar) => isar.responseDataCaches.put(responseCache),
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
