import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

/// Bootstraps the app: runs async initialization then calls [runApp].
///
/// Add any startup work here (Firebase, Hive, error handlers, etc.)
/// before the widget tree is built.
///
/// Flavor entry points call this:
///   // main_dev.dart
///   void main() => bootstrap(environment: AppEnvironment.dev);
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  // Future init steps go here:
  // await Firebase.initializeApp(...);
  // await Hive.initFlutter();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const HarvestApp(),
    ),
  );
}
