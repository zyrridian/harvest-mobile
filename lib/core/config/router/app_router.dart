import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/features/auth/screens/login_screen.dart';
import '../../../presentation/features/auth/screens/register_screen.dart';
import '../../../presentation/features/main/screens/main_screen.dart';
import '../../../presentation/features/farmers/screens/farmers_map_screen.dart';
import '../../../presentation/features/farmers/screens/farmer_detail_screen.dart';
import '../../../presentation/features/settings/screens/settings_screen.dart';
import '../../../presentation/features/subscriptions/screens/subscriptions_screen.dart';
import '../../../presentation/features/subscriptions/screens/subscription_intro_screen.dart';
import '../../../presentation/features/notifications/screens/notifications_screen.dart';
import '../../../presentation/features/addresses/screens/addresses_screen.dart';
import '../../../presentation/features/product/screens/product_detail_screen.dart';
import '../../../domain/entities/farmer.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String farmersMap = '/farmers-map';
  static const String farmerDetail = '/farmer-detail';
  static const String settings = '/settings';
  static const String subscriptionIntro = '/subscription-intro';
  static const String subscriptions = '/subscriptions';
  static const String notifications = '/notifications';
  static const String addresses = '/addresses';
  static const String productDetail = '/product-detail';

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
      GoRoute(
        path: farmerDetail,
        name: 'farmerDetail',
        builder: (context, state) {
          final farmer = state.extra as Farmer;
          return FarmerDetailScreen(farmer: farmer);
        },
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: subscriptionIntro,
        name: 'subscriptionIntro',
        builder: (context, state) => const SubscriptionIntroScreen(),
      ),
      GoRoute(
        path: subscriptions,
        name: 'subscriptions',
        builder: (context, state) => const SubscriptionsScreen(),
      ),
      GoRoute(
        path: notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: addresses,
        name: 'addresses',
        builder: (context, state) => const AddressesScreen(),
      ),
      GoRoute(
        path: productDetail,
        name: 'productDetail',
        builder: (context, state) {
          final productId =
              state.uri.queryParameters['productId'] ?? 'prd_1234567890abcdef';
          return ProductDetailScreen(productId: productId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
}
