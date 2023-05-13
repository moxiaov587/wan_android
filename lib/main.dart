import 'dart:async' show FutureOr, unawaited;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'
    show FlutterNativeSplash;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_web_plugins/url_strategy.dart' show usePathUrlStrategy;
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import 'app/http/http.dart';
import 'app/http/interceptors/interceptors.dart';
import 'app/l10n/generated/l10n.dart';
import 'app/theme/app_theme.dart' show AppTextTheme, AppTheme;
import 'database/app_database.dart';
import 'extensions/extensions.dart' show BuildContextExtension;
import 'model/models.dart';
import 'router/app_router.dart';
import 'screen/authorized/provider/authorized_provider.dart';
import 'screen/provider/common_provider.dart';
import 'utils/dialog_utils.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final (Directory, Isar) sources =
      await (getTemporaryDirectory(), openIsar()).wait;

  // turn off the # in the URLs on the web
  usePathUrlStrategy();

  SystemChrome.setSystemUIOverlayStyle(
    (sources.$2.uniqueUserSettings?.themeMode?.brightness ??
                PlatformDispatcher.instance.platformBrightness) ==
            Brightness.dark
        ? AppTheme.dark.appBarTheme.systemOverlayStyle!
        : AppTheme.light.appBarTheme.systemOverlayStyle!,
  );

  runApp(
    ProviderScope(
      overrides: <Override>[
        appTemporaryDirectoryProvider.overrideWithValue(sources.$1),
        appDatabaseProvider.overrideWithValue(sources.$2),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    unawaited(closeSplash());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Future<void> didChangePlatformBrightness() async {
    requestResetThemeMode();
  }

  FutureOr<void> requestResetThemeMode() {
    if (mounted) {
      final Brightness? brightness = ref.read(appThemeModeProvider).brightness;

      if (brightness != null &&
          brightness !=
              View.of(context).platformDispatcher.platformBrightness) {
        return Future<void>.delayed(const Duration(seconds: 1), () async {
          final bool? data = await DialogUtils.confirm<bool>(
            builder: (BuildContext context) => RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textAlign: TextAlign.center,
              text: TextSpan(
                style: context.theme.textTheme.titleSmall,
                text: S.of(context).currentThemeModeTips,
                children: <InlineSpan>[
                  TextSpan(
                    text: '${S.of(context).themeMode(
                          View.of(context)
                              .platformDispatcher
                              .platformBrightness
                              .name,
                        )}\n',
                    style: const TextStyle(fontWeight: AppTextTheme.semiBold),
                  ),
                  TextSpan(text: S.of(context).resetThemeModeTips),
                ],
              ),
            ),
            confirmCallback: () => Future<bool>.value(true),
          );

          if (data ?? false) {
            ref
                .read(appThemeModeProvider.notifier)
                .switchThemeMode(ThemeMode.system);
          }
        });
      }
    }
  }

  Future<void> closeSplash() async {
    try {
      await ref.read(authorizedProvider.future);
    } on Exception catch (_) {
      /// Ignore exceptions to avoid application blocking.
    }

    final AsyncValue<UserInfoModel?> auth = ref.read(authorizedProvider);

    FlutterNativeSplash.remove();

    await requestResetThemeMode();

    if (auth.hasError) {
      final AppException error =
          AppException.create(auth.error!, auth.stackTrace);

      Future<void>.delayed(const Duration(seconds: 3), () {
        DialogUtils.tips(
          S.current.loginInfoInvalidTips(error.statusCode ?? -1),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = ref.watch(appRouterProvider);
    final ThemeMode themeMode = ref.watch(appThemeModeProvider);
    final Locale? locale = ref.watch(appLanguageProvider)?.locale;

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) => S.of(context).appName,
      routerConfig: goRouter,
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
