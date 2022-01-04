import 'package:beamer/beamer.dart'
    show Beamer, BeamerParser, BeamerBackButtonDispatcher;
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
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
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: AppRouterDelegate.instance.delegate,
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: AppRouterDelegate.instance.delegate,
      ),
      builder: FlutterSmartDialog.init(),

      /// TODO:
      // themeMode: ,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
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
