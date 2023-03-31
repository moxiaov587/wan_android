import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;
import 'package:url_launcher/url_launcher.dart';

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
import '../../utils/screen_utils.dart';
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

  late InAppWebViewController _inAppWebViewController;

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

    _showKeyboardNotifier.value =
        WidgetsBinding.instance.window.viewInsets.bottom != 0;
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
      return _inAppWebViewController.getTitle();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (_canGoBackNotifier.value) {
            await _inAppWebViewController.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () async {
                if (_canGoBackNotifier.value) {
                  await _inAppWebViewController.goBack();
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

                                  final Uri? uri =
                                      await _inAppWebViewController.getUrl();

                                  await Clipboard.setData(
                                    ClipboardData(
                                      text: uri?.toString() ?? article.link,
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
                                ValueListenableBuilder<bool>(
                                  valueListenable: _useDesktopModeNotifier,
                                  builder: (_, bool isDesktop, __) =>
                                      InAppWebView(
                                    key: Key(
                                      '${isDesktop ? 'desktop' : 'recommended'}'
                                      '_${article.link}',
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
                                        javaScriptCanOpenWindowsAutomatically:
                                            true,
                                        transparentBackground: true,
                                        useShouldOverrideUrlLoading: true,
                                        preferredContentMode: isDesktop
                                            ? UserPreferredContentMode.DESKTOP
                                            : UserPreferredContentMode
                                                .RECOMMENDED,
                                      ),
                                      android: AndroidInAppWebViewOptions(
                                        useHybridComposition: true,
                                        forceDark: context.isDarkTheme
                                            ? AndroidForceDark.FORCE_DARK_ON
                                            : AndroidForceDark.FORCE_DARK_OFF,
                                        mixedContentMode:
                                            AndroidMixedContentMode
                                                .MIXED_CONTENT_ALWAYS_ALLOW,
                                        safeBrowsingEnabled: false,
                                      ),
                                      ios: IOSInAppWebViewOptions(
                                        isFraudulentWebsiteWarningEnabled:
                                            false,
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
                                      if (createWindowAction.request.url !=
                                          null) {
                                        await controller.loadUrl(
                                          urlRequest:
                                              createWindowAction.request,
                                        );

                                        return true;
                                      }

                                      return false;
                                    },
                                    onProgressChanged: (_, int progress) {
                                      _progress.add(progress / 100);
                                    },
                                    onLoadStart: (_, Uri? uri) async {
                                      if (article.withCookie) {
                                        await ref
                                            .read(networkProvider)
                                            .syncCookies(uri);
                                      }
                                    },
                                    onLoadStop: (_, __) {
                                      hideProgress();
                                      _loadPagesCountNotifier.value++;
                                    },
                                    shouldOverrideUrlLoading: (
                                      _,
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
                                  disabledColor: context.theme.iconTheme.color!
                                      .withOpacity(0.5),
                                  onPressed: canGoBack
                                      ? () async {
                                          await _inAppWebViewController
                                              .goBack();
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
                                          await _inAppWebViewController
                                              .goForward();
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
                                        const LoginRoute().push(context);
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
                                  await _inAppWebViewController.reload();
                                },
                                icon: const Icon(IconFontIcons.refreshLine),
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: _useDesktopModeNotifier,
                                builder: (_, bool useDesktop, __) => IconButton(
                                  tooltip: useDesktop
                                      ? S.of(context).desktop
                                      : S.of(context).recommend,
                                  onPressed: debounce(
                                    () {
                                      _useDesktopModeNotifier.value =
                                          !useDesktop;
                                    },
                                  ),
                                  color: useDesktop
                                      ? context.theme.primaryColor
                                      : null,
                                  icon: Icon(
                                    useDesktop
                                        ? Icons.desktop_mac
                                        : Icons.devices,
                                  ),
                                ),
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
