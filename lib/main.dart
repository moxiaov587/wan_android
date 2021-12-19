import 'package:beamer/beamer.dart'
    show Beamer, BeamerParser, BeamerBackButtonDispatcher;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/http/http.dart';
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

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: AppRouterDelegate.routerDelegate,
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: AppRouterDelegate.routerDelegate,
      ),

      /// TODO:
      // themeMode: ,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}
