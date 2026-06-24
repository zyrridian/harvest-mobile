import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/presentation/features/community/screens/community_screen.dart';
import 'package:harvest_app/presentation/features/messaging/screens/conversations_list_screen.dart';
import '../../../main.dart';
import 'package:harvest_app/presentation/features/auth/screens/forgot_password_screen.dart';
import '../../../presentation/features/auth/screens/login_screen.dart';
import '../../../presentation/features/auth/screens/role_selection_screen.dart';
import '../../../presentation/features/auth/screens/register_screen.dart';
import '../../../presentation/features/splash/screens/splash_screen.dart';
import '../../../presentation/features/welcome/screens/welcome_screen.dart';
import '../../../presentation/features/main/screens/main_screen.dart';
import '../../../presentation/features/producer/main/screens/farmer_main_screen.dart';
import '../../../presentation/features/producer/dashboard/screens/farmer_dashboard_screen.dart';
import '../../../presentation/features/producer/products/screens/add_product_screen.dart';
import '../../../presentation/features/producer/orders/screens/harvest_schedule_detail_screen.dart';
import '../../../presentation/features/farmers/screens/farmers_map_screen.dart';
import '../../../presentation/features/farmers/screens/farmer_detail_screen.dart';
import '../../../presentation/features/settings/screens/settings_screen.dart';
import '../../../presentation/features/subscriptions/screens/subscriptions_screen.dart';
import '../../../presentation/features/subscriptions/screens/subscription_intro_screen.dart';
import '../../../presentation/features/notifications/screens/notifications_screen.dart';
import '../../../presentation/features/addresses/screens/addresses_screen.dart';
import '../../../presentation/features/product/screens/product_detail_screen.dart';
import '../../../presentation/features/cart/screens/cart_screen.dart';
import '../../../presentation/features/cart/screens/checkout_screen.dart';
import '../../../presentation/features/order/screens/orders_list_screen.dart';
import '../../../presentation/features/order/screens/order_detail_screen.dart';
import '../../../presentation/features/order/screens/order_success_screen.dart';
import '../../../presentation/features/messaging/screens/chat_screen.dart';
import '../../../presentation/features/marketplace/screens/marketplace_screen.dart';
import '../../../presentation/features/preorder/screens/preorder_screen.dart';
import '../../../presentation/features/nearby_farmer/screens/nearby_farmer_screen.dart';
import '../../../presentation/features/harvest_schedule/screens/harvest_schedule_screen.dart';
import '../../../domain/entities/farmer.dart';

class AppRouter {
  // Auth routes
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main routes
  static const String main = '/main';
  static const String community = '/community';
  static const String farmerDashboard = '/farmer-dashboard';
  static const String addProduct = '/add-product';
  static const String harvestScheduleDetail = '/harvest-schedule-detail';
  static const String farmersMap = '/farmers-map';
  static const String farmers = '/farmers'; // farmers list
  static const String products = '/products'; // products list
  static const String preorder = '/preorder'; // preorder list
  static const String harvestSchedule = '/harvest-schedule'; // harvest schedule
  static const String farmerDetail = '/farmer-detail';
  static const String settings = '/settings';
  static const String subscriptionIntro = '/subscription-intro';
  static const String subscriptions = '/subscriptions';
  static const String notifications = '/notifications';
  static const String addresses = '/addresses';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String orderSuccess = '/order-success';
  static const String conversations = '/conversations';
  static const String chat = '/chat';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: splash,
    routes: [
      // Splash screen
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Welcome/Onboarding screen
      GoRoute(
        path: welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: roleSelection,
        name: 'roleSelection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
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
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: main,
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: farmerDashboard,
        name: 'farmerDashboard',
        builder: (context, state) => const FarmerMainScreen(),
      ),
      GoRoute(
        path: addProduct,
        name: 'addProduct',
        builder: (context, state) {
          final extra = state.extra;
          return AddProductScreen(productId: extra is String ? extra : null);
        },
      ),
      GoRoute(
        path: harvestScheduleDetail,
        name: 'harvestScheduleDetail',
        builder: (context, state) => const HarvestScheduleDetailScreen(),
      ),
      GoRoute(
        path: farmersMap,
        name: 'farmersMap',
        builder: (context, state) => const NearbyFarmerScreen(),
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
          final slug =
              state.uri.queryParameters['slug'] ?? 'fresh-lobster-mob94ohd';
          return ProductDetailScreen(slug: slug);
        },
      ),
      // Product detail with path parameter
      GoRoute(
        path: '$products/:slug',
        name: 'productDetailById',
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? 'fresh-lobster-mob94ohd';
          return ProductDetailScreen(slug: slug);
        },
      ),
      GoRoute(
        path: products,
        name: 'products',
        builder: (context, state) => const MarketplaceScreen(),
      ),
      GoRoute(
        path: preorder,
        name: 'preorder',
        builder: (context, state) => const PreOrderScreen(),
      ),
      GoRoute(
        path: harvestSchedule,
        name: 'harvestSchedule',
        builder: (context, state) => const HarvestScheduleScreen(),
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: orders,
        name: 'orders',
        builder: (context, state) => const OrdersListScreen(),
      ),
      GoRoute(
        path: orderDetail,
        name: 'orderDetail',
        builder: (context, state) {
          final orderId =
              state.uri.queryParameters['orderId'] ?? 'ord_1234567890abcdef';
          return OrderDetailScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: orderSuccess,
        name: 'orderSuccess',
        builder: (context, state) {
          final orderId =
              state.uri.queryParameters['orderId'] ?? 'ord_1234567890abcdef';
          final orderNumber =
              state.uri.queryParameters['orderNumber'] ?? 'ORD-000000';
          return OrderSuccessScreen(
            orderId: orderId,
            orderNumber: orderNumber,
          );
        },
      ),
      GoRoute(
        path: conversations,
        name: 'conversations',
        builder: (context, state) => const ConversationsListScreen(),
      ),
      GoRoute(
        path: community,
        name: 'community',
        builder: (context, state) => const CommunityScreen(),
      ),
      GoRoute(
        path: chat,
        name: 'chat',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final conversationId = extra?['conversationId'] as String? ??
              state.uri.queryParameters['conversationId'] ??
              'conv_1234567890abcdef';
          return ChatScreen(
            conversationId: conversationId,
            farmerName: extra?['farmerName'] as String?,
            farmerAvatar: extra?['farmerAvatar'] as String?,
          );
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
