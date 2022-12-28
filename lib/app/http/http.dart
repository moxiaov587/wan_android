import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:diox/diox.dart';
import 'package:diox_cookie_manager/diox_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as web_view
    show CookieManager, HTTPCookieSameSitePolicy;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderContainer;
import 'package:native_diox_adapter/native_diox_adapter.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/log_utils.dart';
import 'cache_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';
import 'network_interceptor.dart';

const String kDomain = 'wanandroid.com';
const String kBaseUrl = 'https://$kDomain';

class Http {
  const Http._();

  static const bool shouldLogRequest = false;

  static final Dio dio = Dio(_options);
  static final Dio tokenDio = Dio(_options);

  static late final PersistCookieJar cookieJar;
  static late final CookieManager cookieManager;

  static final web_view.CookieManager webViewCookieManager =
      web_view.CookieManager.instance();

  static Future<void> initConfig({
    required ProviderContainer providerContainer,
  }) async {
    if (!kIsWeb) {
      await initCookieManagement();

      if (Platform.isIOS || Platform.isMacOS || Platform.isAndroid) {
        dio.httpClientAdapter = NativeAdapter();
      }

      dio.interceptors.add(cookieManager);
    }

    dio.options.baseUrl = kBaseUrl;

    dio.interceptors.addAll(<Interceptor>[
      NetWorkInterceptor(providerContainer: providerContainer),
      ErrorInterceptor(),
      CacheInterceptor(),
    ]);

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

  static Future<void> _setCookie(Cookie cookie) =>
      webViewCookieManager.setCookie(
        url: Uri.parse(kBaseUrl),
        name: cookie.name,
        value: cookie.value,
        domain: cookie.domain ?? kDomain,
        path: cookie.path ?? '/',
        expiresDate: cookie.expires?.millisecondsSinceEpoch,
        isSecure: cookie.secure,
        maxAge: cookie.maxAge,
        sameSite: web_view.HTTPCookieSameSitePolicy.LAX,
      );

  /// Sync local cookies to webview under the same domain name
  static Future<void> syncCookies(Uri? uri) async {
    try {
      final List<Cookie> cookies =
          await cookieJar.loadForRequest(uri ?? Uri.parse(kBaseUrl));

      Future.forEach<Cookie>(cookies, _setCookie);
    } catch (e) {
      LogUtils.e("Error when sync WebView's cookies: $e");
    }
  }

  static Future<bool> get isLogin async =>
      (await cookieJar.loadForRequest(Uri.parse(kBaseUrl))).length > 1;

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
      connectTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
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
}
