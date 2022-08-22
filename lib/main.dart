import 'dart:async' show StreamSubscription, FutureOr;

import 'package:beamer/beamer.dart'
    show Beamer, BeamerParser, BeamerBackButtonDispatcher;
import 'package:connectivity_plus/connectivity_plus.dart'
    show ConnectivityResult;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiOverlayStyle;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'
    show FlutterNativeSplash;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'app/http/http.dart';
import 'app/l10n/generated/l10n.dart';
import 'app/theme/app_theme.dart' show AppTextTheme, AppTheme;
import 'database/database_manager.dart';
import 'extensions/extensions.dart' show BuildContextExtension;
import 'navigator/app_router_delegate.dart';
import 'screen/authorized/provider/authorized_provider.dart';
import 'screen/provider/connectivity_provider.dart';
import 'screen/provider/locale_provider.dart';
import 'screen/provider/theme_provider.dart';
import 'utils/dialog_utils.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await DatabaseManager.openIsar();

  final ProviderContainer providerContainer = ProviderContainer();

  await Http.initConfig(reader: providerContainer.read);

  if (kIsWeb) {
    /// remove the # from URL
    Beamer.setPathUrlStrategy();
  }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
  ));

  AppRouterDelegate.instance.initDelegate(reader: providerContainer.read);

  runApp(UncontrolledProviderScope(
    container: providerContainer,
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    closeSplash();
    ref.read(connectivityProvider.notifier).initData();
    _connectivitySubscription = ref
        .read(connectivityProvider.notifier)
        .onConnectivityChanged
        .listen(ref.read(connectivityProvider.notifier).onConnectivityChange);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    requestResetThemeMode();
  }

  FutureOr<void> requestResetThemeMode() {
    if (mounted) {
      final Brightness? brightness = ref.read(themeProvider).brightness;

      if (brightness != null &&
          brightness != WidgetsBinding.instance.window.platformBrightness) {
        return Future<void>.delayed(const Duration(seconds: 1), () async {
          final bool? data = await DialogUtils.confirm<bool?>(
            builder: (BuildContext context) => RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textAlign: TextAlign.center,
              text: TextSpan(
                style: context.theme.textTheme.titleSmall,
                text: S.of(context).currentThemeModeTips,
                children: <InlineSpan>[
                  TextSpan(
                    text: '${S.of(context).themeMode(
                          WidgetsBinding
                              .instance.window.platformBrightness.name,
                        )}\n',
                    style: const TextStyle(
                      fontWeight: AppTextTheme.semiBold,
                    ),
                  ),
                  TextSpan(
                    text: S.of(context).resetThemeModeTips,
                  ),
                ],
              ),
            ),
            confirmCallback: () => Future<bool>.value(true),
          );

          if (data ?? false) {
            ref.read(themeProvider.notifier).switchThemeMode(ThemeMode.system);
          }
        });
      }
    }
  }

  Future<void> closeSplash() async {
    final int? errorCode =
        await ref.read(authorizedProvider.notifier).initData();
    FlutterNativeSplash.remove();

    await requestResetThemeMode();

    if (errorCode != null) {
      Future<void>.delayed(const Duration(seconds: 3), () {
        DialogUtils.tips(S.current.loginInfoInvalidTips(errorCode));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = ref.watch(themeProvider);
    final Locale? locale = ref.watch(localeProvider);

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) => S.of(context).appName,
      routeInformationParser: BeamerParser(),
      routerDelegate: AppRouterDelegate.instance.delegate,
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: AppRouterDelegate.instance.delegate,
      ),
      builder: FlutterSmartDialog.init(
        builder: (_, Widget? child) => ScrollConfiguration(
          behavior: const AppScrollBehavior(),
          child: child!,
        ),
      ),
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      locale: locale,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}

class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}
