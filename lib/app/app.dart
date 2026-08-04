import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_network_debugger/flutter_network_debugger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/core/config/theme/app_theme.dart';
import 'package:harvest_app/core/localization/app_localizations.dart';
import 'package:harvest_app/core/providers/language_provider.dart';
import 'package:harvest_app/main.dart' show navigatorKey;

/// Root application widget.
/// Owns MaterialApp.router setup, theme, locale, and network debugger.
/// Kept here so main.dart stays razor-thin and flavor entry points
/// (main_dev.dart, main_staging.dart) can reuse this without duplication.
class HarvestApp extends ConsumerWidget {
  const HarvestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Harvest App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return FlutterNetworkDebugger(
          navigatorKey: navigatorKey,
          isDebug: kDebugMode,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
