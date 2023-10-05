import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart'
    show WebViewCookie, WebViewCookieManager;

import '../../utils/log_utils.dart';
import 'interceptors/interceptors.dart';

export 'package:dio/dio.dart' show CancelToken;

export 'api/api.dart';

part 'http.g.dart';

const String kDomain = 'wanandroid.com';
const String kBaseUrl = 'https://$kDomain';

class Http {
  late final Dio dio = Dio(_options);
  late final Dio tokenDio = Dio(_options);

  late final PersistCookieJar cookieJar;
  late final CookieManager cookieManager;

  void initConfig({required Ref ref}) {
    if (!kIsWeb) {
      cookieJar = ref.read(appCookieJarProvider);

      cookieManager = CookieManager(cookieJar);

      dio.interceptors.add(cookieManager);
      tokenDio.interceptors.add(cookieManager);
    }

    dio.options.baseUrl = kBaseUrl;
    tokenDio.options.baseUrl = kBaseUrl;

    dio.interceptors.addAll(<Interceptor>[
      NetWorkInterceptor(ref: ref),
      ErrorInterceptor(ref: ref),
      CacheInterceptor(ref: ref),
    ]);

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor());
      tokenDio.interceptors.add(LogInterceptor());
    }
  }

  /// Sync local cookies to webview under the same domain name
  Future<void> syncCookies(
    WebViewCookieManager webViewCookieManager,
    Uri? uri,
  ) async {
    try {
      final List<Cookie> cookies =
          await cookieJar.loadForRequest(uri ?? Uri.parse(kBaseUrl));

      await Future.forEach<Cookie>(
        cookies,
        (Cookie cookie) => webViewCookieManager.setCookie(
          WebViewCookie(
            name: cookie.name,
            value: cookie.value,
            domain: cookie.domain ?? kDomain,
            path: cookie.path ?? '/',
          ),
        ),
      );
    } on Exception catch (e) {
      LogUtils.e("Error when sync WebView's cookies: $e");
    }
  }

  Future<bool> get isLogin async =>
      (await cookieJar.loadForRequest(Uri.parse(kBaseUrl))).length > 1;

  BaseOptions get _options => BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      );

  Map<String, dynamic> buildMethodGetCacheOptionsExtra({
    bool needCache = false,
    bool needRefresh = false,
    bool isDiskCache = false,
  }) =>
      <String, dynamic>{
        CacheOption.needCache.name: needCache,
        CacheOption.needRefresh.name: needRefresh,
        CacheOption.isDiskCache.name: isDiskCache,
      };
}

extension CancelTokenX on Ref {
  CancelToken cancelToken() {
    final CancelToken cancelToken = CancelToken();
    onDispose(cancelToken.cancel);

    return cancelToken;
  }
}

@Riverpod(keepAlive: true)
external Directory appTemporaryDirectory();

@Riverpod(keepAlive: true, dependencies: <Object>[appTemporaryDirectory])
class AppCookieJar extends _$AppCookieJar {
  @override
  PersistCookieJar build() {
    final Directory directory = ref.read(appTemporaryDirectoryProvider);

    final String path = '${directory.path}/cookie_jar';

    if (!Directory(path).existsSync()) {
      Directory(path).createSync();
    }

    return PersistCookieJar(
      storage: FileStorage(path),
      ignoreExpires: true,
    );
  }
}

@Riverpod(keepAlive: true)
class Network extends _$Network {
  @override
  Http build() => Http()..initConfig(ref: ref);
}
