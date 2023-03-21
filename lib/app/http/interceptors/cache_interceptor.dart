part of 'interceptors.dart';

const Duration _kMaxAgeOfCache = Duration(hours: 12);
const int _kMaxNumOfCacheForMemory = 10;

const String _kGetMethodLowerCase = 'get';

class CacheInterceptor extends Interceptor {
  CacheInterceptor({required this.ref});

  final Ref ref;

  final LinkedHashMap<String, ResponseCache> _cache =
      LinkedHashMap<String, ResponseCache>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final String uriString = options.uri.toString();

    if (options.needRefresh) {
      if (options.isDiskCache) {
        final Isar isar = ref.read(appDatabaseProvider);

        unawaited(
          isar.writeTxn(() async {
            final int? id = await isar.responseCaches
                .filter()
                .uriEqualTo(uriString)
                .idProperty()
                .findFirst();

            if (id != null) {
              await isar.responseCaches.delete(id);
            }
          }),
        );
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

      final Isar isar = ref.read(appDatabaseProvider);

      final Query<ResponseCache> queryBuilder =
          isar.responseCaches.filter().uriEqualTo(uriString).build();

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
          unawaited(isar.writeTxn(queryBuilder.deleteFirst));
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

      final Isar isar = ref.read(appDatabaseProvider);

      if (options.isDiskCache) {
        unawaited(
          isar.writeTxn(() async => isar.responseCaches.put(responseCache)),
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
