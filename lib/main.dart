import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/http/http.dart';
import 'app/theme/theme.dart' show AppTheme;
import 'navigator/route_information_parser.dart';
import 'navigator/router_delegate.dart';

Future<void> main() async {
  await Hive.initFlutter();

  await HttpUtils.initConfig();

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: AppRouteInformationParser(),
      routerDelegate: AppRouterDelegate(),

      /// TODO:
      // themeMode: ,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}
