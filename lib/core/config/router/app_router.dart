import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/features/auth/screens/login_screen.dart';
import '../../../presentation/features/auth/screens/register_screen.dart';
import '../../../presentation/features/main/screens/main_screen.dart';
import '../../../presentation/features/farmers/screens/farmers_map_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String farmersMap = '/farmers-map';

  static final GoRouter router = GoRouter(
    initialLocation: main, //login,
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: main,
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: farmersMap,
        name: 'farmersMap',
        builder: (context, state) => const FarmersMapScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
}
