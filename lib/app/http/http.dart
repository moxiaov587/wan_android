import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'cache_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';

const String kBaseUrl = 'https://www.wanandroid.com';

class Http {
  const Http._();

  static const bool _isProxyEnabled = false;
  static const String _proxyDestination = '';

  static const bool shouldLogRequest = false;

  static final Dio dio = Dio(_options);
  static final Dio tokenDio = Dio(_options);

  static late final PersistCookieJar cookieJar;
  static late final CookieManager cookieManager;

  static Future<void> initConfig() async {
    if (!kIsWeb) {
      await initCookieManagement();

      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          _clientCreate;

      dio.interceptors.add(cookieManager);

      (tokenDio.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = _clientCreate;
    }

    dio.options.baseUrl = kBaseUrl;

    dio.interceptors
      ..add(ErrorInterceptor())
      ..add(CacheInterceptor());

    if (kDebugMode && shouldLogRequest) {
      dio.interceptors.add(LoggingInterceptor());
      tokenDio.interceptors.add(LoggingInterceptor());
    }
  }

  static Future<void> initCookieManagement() async {
    final Directory directory = await getTemporaryDirectory();
    if (!Directory('${directory.path}/cookie_jar').existsSync()) {
      Directory('${directory.path}/cookie_jar').createSync();
    }

    cookieJar = PersistCookieJar(
      storage: FileStorage('${directory.path}/cookie_jar'),
      ignoreExpires: true,
    );
    cookieManager = CookieManager(cookieJar);
  }

  // ignore: long-parameter-list
  static Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    Options? options,
    bool needCache = false,
    bool needRefresh = false,
    bool isDiskCache = false,
  }) =>
      dio.get<T>(
        url,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: (options ?? Options()).copyWith(
          headers: headers,
          extra: <String, dynamic>{
            ...options?.extra ?? <String, dynamic>{},
            ..._buildMethodGetCacheOptionsExtra(
              needCache: needCache,
              needRefresh: needRefresh,
              isDiskCache: isDiskCache,
            ),
          },
        ),
      );

  // ignore: long-parameter-list
  static Future<Response<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    Options? options,
  }) =>
      dio.post<T>(
        url,
        queryParameters: queryParameters,
        data: data,
        options: (options ?? Options()).copyWith(
          headers: headers,
        ),
        cancelToken: cancelToken,
      );

  // ignore: long-parameter-list
  static Future<Response<T>> delete<T>(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    Options? options,
  }) =>
      dio.delete<T>(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: (options ?? Options()).copyWith(
          headers: headers,
        ),
      );

  static BaseOptions get _options {
    return BaseOptions(
      connectTimeout: 60000,
      sendTimeout: 60000,
      receiveTimeout: 60000,
    );
  }

  static Map<String, dynamic> _buildMethodGetCacheOptionsExtra({
    required bool needCache,
    required bool needRefresh,
    required bool isDiskCache,
  }) {
    return <String, dynamic>{
      CacheOption.needCache.name: needCache,
      CacheOption.needRefresh.name: needRefresh,
      CacheOption.isDiskCache.name: isDiskCache,
    };
  }

  static HttpClient? Function(HttpClient client) get _clientCreate =>
      (HttpClient client) {
        if (_isProxyEnabled) {
          client.findProxy = (_) => _proxyDestination;
        }
        client.badCertificateCallback = (_, __, ___) => true;

        return client;
      };
}
