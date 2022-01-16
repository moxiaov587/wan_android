import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'cache_interceptors.dart';
import 'error_interceptors.dart';
import 'logging_interceptors.dart';

class HttpUtils {
  const HttpUtils._();

  static const bool _isProxyEnabled = false;
  static const String _proxyDestination = '';

  static const bool shouldLogRequest = false;

  static final Dio dio = Dio(_options);
  static final Dio tokenDio = Dio(_options);

  static late PersistCookieJar cookieJar;
  static late CookieManager cookieManager;

  static Future<void> updateToken() async {
    dio
      ..lock()
      ..clear();

    /// TODO:
    dio.unlock();
  }

  static Future<void> initConfig() async {
    if (!kIsWeb) {
      await initCookieManagement();

      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          _clientCreate;

      dio.interceptors.add(cookieManager);

      (tokenDio.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = _clientCreate;
    }

    dio.options.baseUrl = 'https://www.wanandroid.com';

    dio.interceptors
      ..add(ErrorInterceptors())
      ..add(CacheInterceptors());

    if (kDebugMode && shouldLogRequest) {
      dio.interceptors.add(LoggingInterceptor());
      tokenDio.interceptors.add(LoggingInterceptor());
    }
  }

  static Future<void> initCookieManagement() async {
    final Directory _d = await getTemporaryDirectory();
    if (!Directory('${_d.path}/cookie_jar').existsSync()) {
      Directory('${_d.path}/cookie_jar').createSync();
    }

    cookieJar = PersistCookieJar(
      storage: FileStorage('${_d.path}/cookie_jar'),
      ignoreExpires: true,
    );
    cookieManager = CookieManager(cookieJar);
  }

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
        options: options,
        cancelToken: cancelToken,
      );

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
        options: options,
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

  static HttpClient? Function(HttpClient client) get _clientCreate {
    return (HttpClient client) {
      if (_isProxyEnabled) {
        client.findProxy = (_) => _proxyDestination;
      }
      client.badCertificateCallback = (_, __, ___) => true;
    };
  }
}
