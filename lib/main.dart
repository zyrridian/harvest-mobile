import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_network_debugger/flutter_network_debugger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/router/app_router.dart';
import 'core/config/theme/app_theme.dart';
import 'core/providers/db_provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/providers/language_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override the sharedPreferencesProvider with the actual instance
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

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
          isDebug: kDebugMode, //false,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
