import 'dart:async' show StreamSubscription;

import 'package:beamer/beamer.dart'
    show Beamer, BeamerParser, BeamerBackButtonDispatcher;
import 'package:connectivity_plus/connectivity_plus.dart'
    show ConnectivityResult;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/http/http.dart';
import 'app/l10n/generated/l10n.dart';
import 'app/theme/theme.dart' show AppTheme;
import 'database/hive_boxes.dart';
import 'navigator/router_delegate.dart';
import 'screen/provider/connectivity_provider.dart';
import 'screen/provider/locale_provider.dart';
import 'screen/provider/theme_provider.dart';

Future<void> main() async {
  await Hive.initFlutter();

  await HiveBoxes.openBoxes();

  await HttpUtils.initConfig();

  if (kIsWeb) {
    /// remove the # from URL
    Beamer.setPathUrlStrategy();
  }

  final ProviderContainer providerContainer = ProviderContainer();

  AppRouterDelegate.instance.initDelegate(reader: providerContainer.read);

  runApp(UncontrolledProviderScope(
    container: providerContainer,
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
    ref.read(connectivityProvider.notifier).initData();
    _connectivitySubscription = ref
        .read(connectivityProvider.notifier)
        .onConnectivityChanged
        .listen(ref.read(connectivityProvider.notifier).updateData);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, WidgetRef ref, __) {
      final ThemeMode themeMode = ref.watch(themeProvider);
      final Locale? locale = ref.watch(localeProvider);

      return MaterialApp.router(
        routeInformationParser: BeamerParser(),
        routerDelegate: AppRouterDelegate.instance.delegate,
        backButtonDispatcher: BeamerBackButtonDispatcher(
          delegate: AppRouterDelegate.instance.delegate,
        ),
        builder: FlutterSmartDialog.init(),
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
    });
  }
}
