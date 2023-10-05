import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../app/http/http.dart';
import '../../app/http/interceptors/interceptors.dart';
import '../../app/l10n/generated/l10n.dart';
import '../../contacts/icon_font_icons.dart';
import '../../extensions/extensions.dart' show BuildContextExtension;
import '../../model/models.dart' show WebViewModel;
import '../../router/data/app_routes.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import '../../utils/debounce_throttle.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/html_parse_utils.dart';
import '../../widget/popup_menu.dart';
import '../../widget/view_state_widget.dart';
import 'provider/article_provider.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  const ArticleScreen({
    required this.id,
    super.key,
  });

  final int id;

  @override
  ConsumerState<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen>
    with WidgetsBindingObserver {
  late final AppArticleProvider provider = appArticleProvider(widget.id);

  final StreamController<double> _progress =
      StreamController<double>.broadcast();

  Timer? _hideProgressTimer;

  late WebViewController _webViewController;

  final ValueNotifier<bool> _showKeyboardNotifier = ValueNotifier<bool>(false);

  final ValueNotifier<bool> _useDesktopModeNotifier =
      ValueNotifier<bool>(false);

  final ValueNotifier<bool> _canGoBackNotifier = ValueNotifier<bool>(false);

  final ValueNotifier<bool> _canGoForwardModeNotifier =
      ValueNotifier<bool>(false);

  final ValueNotifier<int> _loadPagesCountNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    _showKeyboardNotifier.value = View.of(context).viewInsets.bottom != 0;
  }

  @override
  void dispose() {
    unawaited(SystemChannels.textInput.invokeMethod<void>('TextInput.hide'));
    unawaited(_progress.close());
    _hideProgressTimer?.cancel();
    _useDesktopModeNotifier.dispose();
    _canGoBackNotifier.dispose();
    _canGoForwardModeNotifier.dispose();
    _showKeyboardNotifier.dispose();
    _loadPagesCountNotifier.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void hideProgress([Duration duration = const Duration(seconds: 1)]) {
    _hideProgressTimer?.cancel();
    _hideProgressTimer = Timer(duration, () {
      if (!_progress.isClosed) {
        _progress.add(0.0);
      }
    });
  }

  Future<String?> _getTitle() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      return _webViewController.getTitle();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: _canGoBackNotifier,
        builder: (BuildContext context, bool canGoBack, Widget? child) =>
            PopScope(
          canPop: !canGoBack,
          child: child!,
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () async {
                if (_canGoBackNotifier.value) {
                  await _webViewController.goBack();
                } else {
                  await Navigator.of(context).maybePop();
                }
              },
            ),
            title: Consumer(
              builder: (BuildContext context, WidgetRef ref, _) => ref
                  .watch(provider)
                  .when(
                    data: (_) => ValueListenableBuilder<int>(
                      valueListenable: _loadPagesCountNotifier,
                      builder: (BuildContext context, int count, __) =>
                          FutureBuilder<String?>(
                        // ignore: discarded_futures
                        future: _getTitle(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<String?> snapshot,
                        ) {
                          late String title;

                          if (count == 0) {
                            title = S.of(context).loading;
                          } else if (snapshot.hasError) {
                            title = S.of(context).loadFailed;
                          } else {
                            title =
                                HTMLParseUtils.unescapeHTML(snapshot.data) ??
                                    S.of(context).unknown;
                          }

                          return Text(title);
                        },
                      ),
                    ),
                    error: (_, __) => Text(S.of(context).loadFailed),
                    loading: () => Text(S.of(context).loading),
                  ),
            ),
            actions: <Widget>[
              Consumer(
                builder: (_, WidgetRef ref, __) =>
                    ref.watch(provider).whenOrNull(
                          data: (WebViewModel article) => PopupMenu(
                            iconData: IconFontIcons.moreFill,
                            children: <PopupMenuItemConfig>[
                              PopupMenuItemConfig(
                                iconData: IconFontIcons.clipboardLine,
                                label: S.of(context).copyLink,
                                onTap: () async {
                                  final S l10n = S.of(context);

                                  final String? url =
                                      await _webViewController.currentUrl();

                                  await Clipboard.setData(
                                    ClipboardData(
                                      text: url ?? article.link,
                                    ),
                                  );

                                  DialogUtils.success(l10n.copiedToClipboard);
                                },
                              ),
                              PopupMenuItemConfig(
                                iconData: IconFontIcons.externalLinkLine,
                                label: S.of(context).browser,
                                onTap: () async {
                                  final Uri uri = Uri.parse(article.link);

                                  final S l10n = S.of(context);

                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    DialogUtils.danger(
                                      l10n.unableToOpenLink(uri.toString()),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ) ??
                    const SizedBox.shrink(),
              ),
            ],
          ),
          body: Consumer(
            builder: (
              BuildContext context,
              WidgetRef ref,
              Widget? bottomActionBar,
            ) =>
                ref.watch(provider).when(
                      skipLoadingOnRefresh: false,
                      data: (WebViewModel article) => Column(
                        children: <Widget>[
                          Expanded(
                            child: Stack(
                              children: <Widget>[
                                WebView(
                                  url: Uri.parse(article.link),
                                  withCookies: article.withCookie,
                                  onWebViewInit:
                                      (WebViewController controller) {
                                    _webViewController = controller;
                                  },
                                  onPageStarted:
                                      (WebViewController controller) {},
                                  onProgress: (
                                    WebViewController controller,
                                    double progress,
                                  ) {
                                    _progress.add(progress / 100);
                                  },
                                  onPageFinished: (
                                    WebViewController controller,
                                  ) {
                                    _loadPagesCountNotifier.value++;
                                  },
                                  onUrlChange: (
                                    WebViewController controller,
                                    UrlChange change,
                                  ) {
                                    hideProgress();

                                    Future<void>.delayed(
                                      const Duration(milliseconds: 500),
                                      () async {
                                        if (mounted) {
                                          final (bool, bool) result = await (
                                            controller.canGoBack(),
                                            controller.canGoForward()
                                          ).wait;

                                          _canGoBackNotifier.value = result.$1;
                                          _canGoForwardModeNotifier.value =
                                              result.$2;
                                        }
                                      },
                                    );
                                  },
                                ),
                                Positioned(
                                  child: PreferredSize(
                                    preferredSize:
                                        Size(context.mqSize.width, 5.0),
                                    child: StreamBuilder<double>(
                                      stream: _progress.stream,
                                      initialData: 0.0,
                                      builder:
                                          (_, AsyncSnapshot<double> snapshot) =>
                                              LinearProgressIndicator(
                                        backgroundColor: Colors.transparent,
                                        value: snapshot.data,
                                        minHeight: 4.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          bottomActionBar!,
                        ],
                      ),
                      loading: () => const LoadingWidget.listView(),
                      error: (Object e, StackTrace s) =>
                          CustomErrorWidget.withAppException(
                        AppException.create(e, s),
                        onRetry: () {
                          ref.invalidate(provider);
                        },
                      ),
                    ),
            child: ValueListenableBuilder<bool>(
              valueListenable: _showKeyboardNotifier,
              builder: (_, bool showKeyboard, __) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.elasticOut,
                switchOutCurve: Curves.elasticIn,
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        SizeTransition(sizeFactor: animation, child: child),
                child: showKeyboard
                    ? nil
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.background,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: context.theme.colorScheme.background
                                  .withAlpha(100),
                              offset: const Offset(0.0, -2.0),
                              blurRadius: 8.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: context.mqPadding.bottom),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ValueListenableBuilder<bool>(
                                valueListenable: _canGoBackNotifier,
                                builder: (_, bool canGoBack, __) => IconButton(
                                  tooltip: S.of(context).back,
                                  disabledColor: context.theme.iconTheme.color!
                                      .withOpacity(0.5),
                                  onPressed: canGoBack
                                      ? () async {
                                          await _webViewController.goBack();
                                        }
                                      : null,
                                  icon: const Icon(Icons.arrow_back_ios_new),
                                ),
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: _canGoForwardModeNotifier,
                                builder: (_, bool canGoForward, __) =>
                                    IconButton(
                                  tooltip: S.of(context).forward,
                                  disabledColor: context.theme.iconTheme.color!
                                      .withOpacity(0.5),
                                  onPressed: canGoForward
                                      ? () async {
                                          await _webViewController.goForward();
                                        }
                                      : null,
                                  icon: const Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                              Consumer(
                                builder: (_, WidgetRef ref, __) {
                                  final bool collect = ref.watch(
                                    provider.select(
                                      (AsyncValue<WebViewModel> value) =>
                                          value.whenOrNull(
                                            data: (WebViewModel? article) =>
                                                article!.collect,
                                          ) ??
                                          false,
                                    ),
                                  );

                                  return IconButton(
                                    tooltip: collect
                                        ? S.of(context).collected
                                        : S.of(context).collect,
                                    color: collect
                                        ? context.theme.primaryColor
                                        : null,
                                    onPressed: throttle(() async {
                                      if (ref
                                              .read(authorizedProvider)
                                              .valueOrNull !=
                                          null) {
                                        await ref
                                            .read(provider.notifier)
                                            .collect(value: !collect);
                                      } else {
                                        unawaited(
                                          const LoginRoute().push(context),
                                        );
                                      }
                                    }),
                                    icon: Icon(
                                      collect
                                          ? IconFontIcons.starFill
                                          : IconFontIcons.starLine,
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                tooltip: S.of(context).refresh,
                                onPressed: () async {
                                  await _webViewController.reload();
                                },
                                icon: const Icon(IconFontIcons.refreshLine),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
}

typedef OnWebViewInit = void Function(WebViewController controller);
typedef OnNavigationRequestCallback = FutureOr<NavigationDecision> Function(
  WebViewController controller,
  NavigationRequest navigationRequest,
);
typedef OnPageStartedCallback = void Function(WebViewController controller);
typedef OnPageFinishedCallback = void Function(WebViewController controller);
typedef OnProgressCallback = void Function(
  WebViewController controller,
  double progress,
);
typedef OnWebResourceErrorCallback = void Function(
  WebViewController controller,
  WebResourceError resourceError,
);
typedef OnUrlChangeCallback = void Function(
  WebViewController controller,
  UrlChange change,
);

class WebView extends ConsumerStatefulWidget {
  const WebView({
    required this.url,
    this.withCookies = false,
    this.onWebViewInit,
    this.onNavigationRequest,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
    this.onUrlChange,
    super.key,
  });

  final Uri url;
  final bool withCookies;
  final OnWebViewInit? onWebViewInit;
  final OnNavigationRequestCallback? onNavigationRequest;
  final OnPageStartedCallback? onPageStarted;
  final OnPageFinishedCallback? onPageFinished;
  final OnProgressCallback? onProgress;
  final OnWebResourceErrorCallback? onWebResourceError;
  final OnUrlChangeCallback? onUrlChange;

  @override
  ConsumerState<WebView> createState() => __WebViewState();
}

class __WebViewState extends ConsumerState<WebView> {
  late final WebViewController _controller;

  late final WebViewCookieManager _cookieManager;

  @override
  void initState() {
    super.initState();

    PlatformWebViewControllerCreationParams controllerParams =
        const PlatformWebViewControllerCreationParams();

    PlatformWebViewCookieManagerCreationParams cookieManagerParams =
        const PlatformWebViewCookieManagerCreationParams();

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      controllerParams = WebKitWebViewControllerCreationParams
          .fromPlatformWebViewControllerCreationParams(
        controllerParams,
      );

      cookieManagerParams = WebKitWebViewCookieManagerCreationParams
          .fromPlatformWebViewCookieManagerCreationParams(
        cookieManagerParams,
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      controllerParams = AndroidWebViewControllerCreationParams
          .fromPlatformWebViewControllerCreationParams(
        controllerParams,
      );

      cookieManagerParams = AndroidWebViewCookieManagerCreationParams
          .fromPlatformWebViewCookieManagerCreationParams(
        cookieManagerParams,
      );
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(controllerParams);

    _cookieManager =
        WebViewCookieManager.fromPlatformCreationParams(cookieManagerParams);

    Future<void>.microtask(() async {
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async =>
              await widget.onNavigationRequest?.call(_controller, request) ??
              NavigationDecision.navigate,
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            widget.onPageStarted?.call(_controller);
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            widget.onPageFinished?.call(_controller);
          },
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
            widget.onProgress?.call(_controller, progress / 100);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
                Page resource error:
                  code: ${error.errorCode}
                  description: ${error.description}
                  errorType: ${error.errorType}
                  isForMainFrame: ${error.isForMainFrame}
              ''');

            widget.onWebResourceError?.call(_controller, error);
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');

            widget.onUrlChange?.call(_controller, change);
          },
        ),
      );

      if (widget.withCookies) {
        await ref.read(networkProvider).syncCookies(_cookieManager, widget.url);
      } else {
        await _cookieManager.clearCookies();
      }

      await controller.loadRequest(widget.url);
    });

    _controller = controller;

    widget.onWebViewInit?.call(controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    unawaited(
      _controller.setBackgroundColor(context.theme.colorScheme.background),
    );
  }

  @override
  void didUpdateWidget(covariant WebView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url) {
      unawaited(_controller.loadRequest(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      return WebViewWidget.fromPlatformCreationParams(
        params: WebKitWebViewWidgetCreationParams(
          controller: _controller.platform,
        ),
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      return WebViewWidget.fromPlatformCreationParams(
        params: AndroidWebViewWidgetCreationParams(
          controller: _controller.platform,
          displayWithHybridComposition: true,
        ),
      );
    }
    return WebViewWidget(controller: _controller);
  }
}
