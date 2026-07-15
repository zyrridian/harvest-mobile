import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/features/community/presentation/screens/community_screen.dart';
import 'package:harvest_app/features/community/presentation/screens/conversations_list_screen.dart';
import 'package:harvest_app/features/sourcing/domain/entities/sourcing_request.dart';
import '../../../main.dart';
import 'package:harvest_app/features/auth/presentation/screens/forgot_password_screen.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../../features/auth/presentation/screens/register_screen.dart';
import '../../../features/auth/presentation/screens/terms_of_service_screen.dart';
import '../../../features/auth/presentation/screens/privacy_policy_screen.dart';
import '../../../presentation/features/splash/screens/splash_screen.dart';
import '../../../presentation/features/welcome/screens/welcome_screen.dart';
import '../../../presentation/features/main/screens/main_screen.dart';
import '../../../presentation/features/producer/main/screens/farmer_main_screen.dart';
import '../../../presentation/features/producer/products/screens/farmer_add_edit_product_screen.dart';
import '../../../presentation/features/producer/orders/screens/harvest_schedule_detail_screen.dart';
import '../../../features/explore/presentation/screens/explore_screen.dart';
import '../../../features/farmers/presentation/screens/farmer_detail_screen.dart';
import '../../../features/users/presentation/screens/settings_screen.dart';
import '../../../presentation/features/subscriptions/screens/subscriptions_screen.dart';
import '../../../presentation/features/subscriptions/screens/subscription_intro_screen.dart';
import '../../../presentation/features/producer/settings/screens/edit_farm_profile_screen.dart';
import '../../../presentation/features/producer/settings/screens/farm_reviews_screen.dart';
import '../../../presentation/features/producer/settings/screens/delivery_settings_screen.dart';
import '../../../presentation/features/producer/settings/screens/drop_points_screen.dart';
import '../../../presentation/features/producer/settings/screens/edit_drop_point_screen.dart';
import '../../../presentation/features/notifications/screens/notifications_screen.dart';
import '../../../features/users/presentation/screens/addresses_screen.dart';
import '../../../features/catalog/presentation/screens/product_detail_screen.dart';
import 'package:harvest_app/presentation/features/producer/settings/screens/manage_gallery_screen.dart';
import '../../../features/sales/presentation/screens/cart/cart_screen.dart';
import '../../../features/sales/presentation/screens/cart/checkout_screen.dart';
import '../../../features/sales/presentation/screens/orders/orders_list_screen.dart';
import '../../../features/sales/presentation/screens/orders/order_detail_screen.dart';
import '../../../features/sales/presentation/screens/orders/order_success_screen.dart';
import '../../../features/community/presentation/screens/chat_screen.dart';
import '../../../features/community/presentation/screens/image_viewer_screen.dart';
import '../../../features/storefront/presentation/screens/marketplace_screen.dart';
import '../../../features/sourcing/presentation/screens/farmer_sourcing_requests_screen.dart';
import '../../../features/sourcing/presentation/screens/buyer_sourcing_requests_screen.dart';
import '../../../features/sourcing/presentation/screens/create_sourcing_request_screen.dart';
import '../../../features/sourcing/presentation/screens/farmer_sourcing_offers_screen.dart';
import '../../../features/sourcing/presentation/screens/buyer_request_details_screen.dart';
import '../../../features/storefront/presentation/screens/category_products_screen.dart';
import 'package:harvest_app/domain/entities/marketplace.dart';
import '../../../features/preorders/presentation/screens/preorder_screen.dart';
import '../../../features/preorders/presentation/screens/preorder_detail_screen.dart';
import '../../../features/preorders/presentation/screens/preorder_reservations_screen.dart';
import '../../../presentation/features/nearby_farmer/screens/nearby_farmer_screen.dart';
import '../../../presentation/features/harvest_schedule/screens/harvest_schedule_screen.dart';
import '../../../presentation/features/producer/route_plan/screens/route_plan_screen.dart';
import '../../../domain/entities/farmer.dart';
import '../../../domain/entities/drop_point.dart';

class AppRouter {
  // Auth routes
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String termsOfService = '/terms-of-service';
  static const String privacyPolicy = '/privacy-policy';

  // Main routes
  static const String main = '/main';
  static const String community = '/community';
  static const String farmerDashboard = '/farmer-dashboard';
  static const String editFarmProfile = '/edit-farm-profile';
  static const String manageGallery = '/manage-gallery';
  static const String farmReviews = '/farm-reviews';
  static const String deliverySettings = '/delivery-settings';
  static const String dropPoints = '/drop-points';
  static const String editDropPoint = '/edit-drop-point';
  static const String addProduct = '/add-product';
  static const String harvestScheduleDetail = '/harvest-schedule-detail';
  static const String routePlan = '/route-plan';
  static const String explore = '/explore';
  static const String farmers = '/farmers'; // farmers list
  static const String products = '/products'; // products list
  static const String preorder = '/preorder'; // preorder list
  static const String preorderReservations =
      '/preorder-reservations'; // preorder reservations
  static const String preorderDetail = '/preorder/:slug'; // preorder detail
  static const String harvestSchedule = '/harvest-schedule'; // harvest schedule
  static const String nearbyFarmers = '/nearby-farmers'; // nearby farmers
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
  static const String imageViewer = '/image-viewer';
  static const String farmerSourcingRequests = '/farmer-sourcing-requests';
  static const String buyerSourcingRequests = '/buyer-sourcing-requests';
  static const String createSourcingRequest = '/create-sourcing-request';
  static const String farmerSourcingOffers = '/farmer-sourcing-offers';
  static const String buyerRequestDetails = '/buyer-request-details';

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
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'CONSUMER';
          return LoginScreen(role: role);
        },
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'CONSUMER';
          return RegisterScreen(role: role);
        },
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: termsOfService,
        name: 'termsOfService',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      GoRoute(
        path: privacyPolicy,
        name: 'privacyPolicy',
        builder: (context, state) => const PrivacyPolicyScreen(),
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
        path: editFarmProfile,
        name: 'editFarmProfile',
        builder: (context, state) => const EditFarmProfileScreen(),
      ),
      GoRoute(
        path: manageGallery,
        name: 'manageGallery',
        builder: (context, state) => const ManageGalleryScreen(),
      ),
      GoRoute(
        path: farmReviews,
        name: 'farmReviews',
        builder: (context, state) => const FarmReviewsScreen(),
      ),
      GoRoute(
        path: deliverySettings,
        name: 'deliverySettings',
        builder: (context, state) => const DeliverySettingsScreen(),
      ),
      GoRoute(
        path: dropPoints,
        name: 'dropPoints',
        builder: (context, state) => const DropPointsScreen(),
      ),
      GoRoute(
        path: editDropPoint,
        name: 'editDropPoint',
        builder: (context, state) {
          final dropPoint = state.extra as DropPoint?;
          return EditDropPointScreen(dropPoint: dropPoint);
        },
      ),
      GoRoute(
        path: addProduct,
        name: 'addProduct',
        builder: (context, state) {
          final extra = state.extra;
          return FarmerAddEditProductScreen(
              productId: extra is String ? extra : null);
        },
      ),
      GoRoute(
        path: harvestScheduleDetail,
        name: 'harvestScheduleDetail',
        builder: (context, state) => const HarvestScheduleDetailScreen(),
      ),
      GoRoute(
        path: nearbyFarmers,
        name: 'nearbyFarmers',
        builder: (context, state) => const NearbyFarmerScreen(),
      ),
      GoRoute(
        path: routePlan,
        name: 'routePlan',
        builder: (context, state) => const RoutePlanScreen(),
      ),
      GoRoute(
        path: explore,
        name: 'explore',
        builder: (context, state) => const ExploreScreen(isTab: false),
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
        path: '/category/:id',
        name: 'categoryProducts',
        builder: (context, state) {
          final category = state.extra as MarketplaceCategory?;
          final categoryId = state.pathParameters['id'] ?? '';
          return CategoryProductsScreen(
              categoryId: categoryId, category: category);
        },
      ),
      GoRoute(
        path: preorder,
        name: 'preorder',
        builder: (context, state) => const PreOrderScreen(),
      ),
      GoRoute(
        path: preorderReservations,
        name: 'preorderReservations',
        builder: (context, state) => const PreOrderReservationsScreen(),
      ),
      GoRoute(
        path: preorderDetail,
        name: 'preorderDetail',
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? 'unknown';
          return PreOrderDetailScreen(slug: slug);
        },
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
          final paymentMethod =
              state.uri.queryParameters['paymentMethod'] ?? 'cod';
          return OrderSuccessScreen(
            orderId: orderId,
            orderNumber: orderNumber,
            paymentMethod: paymentMethod,
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
      GoRoute(
        path: imageViewer,
        name: 'imageViewer',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ImageViewerScreen(
            heroTag: extra['heroTag'] as String? ?? 'default',
            imageUrl: extra['imageUrl'] as String? ?? '',
            isLocal: extra['isLocal'] as bool? ?? false,
          );
        },
      ),
      GoRoute(
        path: farmerSourcingRequests,
        builder: (context, state) => const FarmerSourcingRequestsScreen(),
      ),
      GoRoute(
        path: buyerSourcingRequests,
        builder: (context, state) => const BuyerSourcingRequestsScreen(),
      ),
      GoRoute(
        path: createSourcingRequest,
        builder: (context, state) => const CreateSourcingRequestScreen(),
      ),
      GoRoute(
        path: farmerSourcingOffers,
        builder: (context, state) => const FarmerSourcingOffersScreen(),
      ),
      GoRoute(
        path: buyerRequestDetails,
        builder: (context, state) {
          final req = state.extra as SourcingRequest;
          return BuyerRequestDetailsScreen(request: req);
        }
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
}
