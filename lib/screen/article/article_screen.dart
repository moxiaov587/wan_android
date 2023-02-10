import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;
import 'package:url_launcher/url_launcher.dart';

import '../../app/http/http.dart';
import '../../app/l10n/generated/l10n.dart';
import '../../app/provider/view_state.dart';
import '../../contacts/icon_font_icons.dart';
import '../../extensions/extensions.dart' show BuildContextExtension;
import '../../model/models.dart' show WebViewModel;
import '../../router/data/app_routes.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import '../../utils/debounce_throttle.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/html_parse_utils.dart';
import '../../utils/screen_utils.dart';
import '../../widget/popup_menu.dart';
import '../../widget/view_state_widget.dart';
import 'provider/article_provider.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  const ArticleScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen>
    with WidgetsBindingObserver {
  late final AutoDisposeStateNotifierProvider<ArticleNotifier,
      ViewState<WebViewModel>> provider = articleProvider(widget.id);

  final StreamController<double> _progress =
      StreamController<double>.broadcast();

  Timer? _hideProgressTimer;

  late InAppWebViewController _inAppWebViewController;

  final ValueNotifier<bool> _showKeyboardNotifier = ValueNotifier<bool>(false);

  final ValueNotifier<bool> _useDesktopModeNotifier =
      ValueNotifier<bool>(false);

  final ValueNotifier<bool> _canGoBackNotifier = ValueNotifier<bool>(false);

  final ValueNotifier<bool> _canGoForwardModeNotifier =
      ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    ref.read(provider.notifier).initData();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    _showKeyboardNotifier.value =
        WidgetsBinding.instance.window.viewInsets.bottom != 0;
  }

  @override
  void dispose() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    _progress.close();
    _hideProgressTimer?.cancel();
    _useDesktopModeNotifier.dispose();
    _canGoBackNotifier.dispose();
    _canGoForwardModeNotifier.dispose();
    _showKeyboardNotifier.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (_, WidgetRef ref, __) {
            final String? title = ref.watch(
              provider.select(
                (ViewState<WebViewModel> value) => value.when(
                  (WebViewModel? value) => value?.title,
                  loading: () => S.of(context).loading,
                  error: (_, __, ___) => S.of(context).loadFailed,
                ),
              ),
            );

            return Text(
              HTMLParseUtils.unescapeHTML(title) ?? S.of(context).unknown,
            );
          },
        ),
        actions: <Widget>[
          Consumer(
            builder: (_, WidgetRef ref, Widget? empty) {
              final WebViewModel? article = ref.watch(
                provider.select(
                  (ViewState<WebViewModel> model) =>
                      model.whenOrNull<WebViewModel?>(
                    (WebViewModel? article) => article,
                  ),
                ),
              );

              return article != null
                  ? PopupMenu(
                      iconData: IconFontIcons.moreFill,
                      children: <PopupMenuItemConfig>[
                        PopupMenuItemConfig(
                          iconData: IconFontIcons.clipboardLine,
                          label: S.of(context).copyLink,
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: article.link),
                            );
                            DialogUtils.success(
                              S.of(context).copiedToClipboard,
                            );
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
                    )
                  : empty!;
            },
            child: const SizedBox.shrink(),
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
                  (WebViewModel? article) => Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            ValueListenableBuilder<bool>(
                              valueListenable: _useDesktopModeNotifier,
                              builder: (_, bool useDesktopMode, __) =>
                                  InAppWebView(
                                key: ValueKey<String>(
                                  '${useDesktopMode ? 'desktop' : 'recommended'}_${article!.link}',
                                ),
                                initialUrlRequest: URLRequest(
                                  url: Uri.parse(article.link),
                                ),
                                initialOptions: InAppWebViewGroupOptions(
                                  crossPlatform: InAppWebViewOptions(
                                    cacheEnabled: article.withCookie,
                                    clearCache: !article.withCookie,
                                    horizontalScrollBarEnabled: false,
                                    verticalScrollBarEnabled: false,
                                    javaScriptCanOpenWindowsAutomatically: true,
                                    transparentBackground: true,
                                    useShouldOverrideUrlLoading: true,
                                    preferredContentMode: useDesktopMode
                                        ? UserPreferredContentMode.DESKTOP
                                        : UserPreferredContentMode.RECOMMENDED,
                                  ),
                                  android: AndroidInAppWebViewOptions(
                                    useHybridComposition: true,
                                    forceDark: context.isDarkTheme
                                        ? AndroidForceDark.FORCE_DARK_ON
                                        : AndroidForceDark.FORCE_DARK_OFF,
                                    mixedContentMode: AndroidMixedContentMode
                                        .MIXED_CONTENT_ALWAYS_ALLOW,
                                    safeBrowsingEnabled: false,
                                  ),
                                  ios: IOSInAppWebViewOptions(
                                    isFraudulentWebsiteWarningEnabled: false,
                                  ),
                                ),
                                onWebViewCreated:
                                    (InAppWebViewController controller) {
                                  _inAppWebViewController = controller;
                                },
                                onCreateWindow: (
                                  InAppWebViewController controller,
                                  CreateWindowAction createWindowAction,
                                ) async {
                                  if (createWindowAction.request.url != null) {
                                    await controller.loadUrl(
                                      urlRequest: createWindowAction.request,
                                    );

                                    return true;
                                  }

                                  return false;
                                },
                                onProgressChanged: (_, int progress) {
                                  _progress.add(progress / 100);
                                },
                                onLoadStart: (_, Uri? uri) {
                                  if (article.withCookie) {
                                    Http.syncCookies(uri);
                                  }
                                },
                                onLoadStop: (
                                  InAppWebViewController controller,
                                  Uri? url,
                                ) {
                                  hideProgress();
                                },
                                shouldOverrideUrlLoading: (
                                  InAppWebViewController controller,
                                  NavigationAction navigationAction,
                                ) async {
                                  if (!<String>[
                                    'http',
                                    'https',
                                    'file',
                                    'chrome',
                                    'data',
                                    'javascript',
                                    'about',
                                  ].contains(
                                    navigationAction.request.url?.scheme,
                                  )) {
                                    return NavigationActionPolicy.CANCEL;
                                  }

                                  return NavigationActionPolicy.ALLOW;
                                },
                                onUpdateVisitedHistory:
                                    (_, Uri? uri, bool? androidIsReload) {
                                  hideProgress();

                                  Future<void>.delayed(
                                    const Duration(milliseconds: 500),
                                    () async {
                                      if (mounted) {
                                        _canGoBackNotifier.value =
                                            await _inAppWebViewController
                                                .canGoBack();
                                        _canGoForwardModeNotifier.value =
                                            await _inAppWebViewController
                                                .canGoForward();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              child: PreferredSize(
                                preferredSize: Size(ScreenUtils.width, 5.0),
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
                  loading: () => const LoadingWidget(),
                  error: (int? statusCode, String? message, String? detail) =>
                      CustomErrorWidget(
                    statusCode: statusCode,
                    message: message,
                    detail: detail,
                    onRetry: ref.read(provider.notifier).initData,
                  ),
                ),
        child: ValueListenableBuilder<bool>(
          valueListenable: _showKeyboardNotifier,
          builder: (_, bool showKeyboard, Widget? child) => AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 300,
            ),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (Widget child, Animation<double> animation) =>
                SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
            child: showKeyboard ? nil : child,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.background,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: context.theme.colorScheme.background.withAlpha(100),
                  offset: const Offset(0.0, -2.0),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtils.bottomSafeHeight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ValueListenableBuilder<bool>(
                    valueListenable: _canGoBackNotifier,
                    builder: (_, bool canGoBack, __) => IconButton(
                      tooltip: S.of(context).back,
                      disabledColor:
                          context.theme.iconTheme.color!.withOpacity(0.5),
                      onPressed: canGoBack
                          ? () {
                              _inAppWebViewController.goBack();
                            }
                          : null,
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _canGoForwardModeNotifier,
                    builder: (_, bool canGoForward, __) => IconButton(
                      tooltip: S.of(context).forward,
                      disabledColor:
                          context.theme.iconTheme.color!.withOpacity(0.5),
                      onPressed: canGoForward
                          ? () {
                              _inAppWebViewController.goForward();
                            }
                          : null,
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final bool collect = ref.watch(
                        provider.select(
                          (ViewState<WebViewModel> value) =>
                              value.whenOrNull(
                                (WebViewModel? article) => article!.collect,
                              ) ??
                              false,
                        ),
                      );

                      return IconButton(
                        tooltip: collect
                            ? S.of(context).collected
                            : S.of(context).collect,
                        color: collect ? context.theme.primaryColor : null,
                        onPressed: throttle(() {
                          if (ref.read(authorizedProvider) == null) {
                            const LoginRoute().push(context);
                          } else {
                            ref.read(provider.notifier).collect(!collect);
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
                    onPressed: () {
                      _inAppWebViewController.reload();
                    },
                    icon: const Icon(
                      IconFontIcons.refreshLine,
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _useDesktopModeNotifier,
                    builder: (
                      _,
                      bool useDesktop,
                      __,
                    ) =>
                        IconButton(
                      tooltip: useDesktop
                          ? S.of(context).desktop
                          : S.of(context).recommend,
                      onPressed: debounce(
                        () {
                          _useDesktopModeNotifier.value = !useDesktop;
                        },
                      ),
                      color: useDesktop ? context.theme.primaryColor : null,
                      icon: Icon(
                        useDesktop ? Icons.desktop_mac : Icons.devices,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
