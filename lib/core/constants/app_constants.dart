class AppConstants {
  // Image Placeholders
  static const String placeholderImage = 'https://picsum.photos/400/400';

  // API Configuration
  // TODO: Update this to your actual API URL
  // For development, you can use: http://10.0.2.2:3000 (Android emulator localhost)
  // or http://localhost:3000 (web/desktop)
  static const String baseUrl = String.fromEnvironment('BASE_URL',
      defaultValue: 'https://marketplace.zyrridian.dev');
  static const String apiVersion = '/api/v1';

  // API Endpoints - Auth
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String getCurrentUserEndpoint = '/auth/me';

  // API Endpoints - Home
  static const String getHomeDataEndpoint = '/storefront/home';
  static const String marketplaceDataEndpoint = '/storefront/marketplace';
  static const String categoriesEndpoint = '/categories';

  // API Endpoints - Producer/Farmer
  static const String producerProfileEndpoint = '/farmers/me';
  static const String producerStatsEndpoint = '/farmers/me/stats';
  static const String producerProductsEndpoint = '/farmers/me/products';
  static const String producerOrdersEndpoint = '/farmers/me/orders';
  static const String producerDropPointsEndpoint = '/farmers/me/drop-points';
  static const String producerDeliverySettingsEndpoint =
      '/farmers/me/delivery-settings';
  static const String producerRoutesEndpoint = '/farmers/me/routes';
  static const String producerReviewsEndpoint = '/farmers/me/reviews';

  // Farmers
  static const String farmersEndpoint = '/farmers';
  static const String farmerByIdEndpoint = '/farmers/:id';
  static const String farmerProductsEndpoint = '/farmers/:id/products';
  static const String farmerReviewsEndpoint = '/farmers/:id/reviews';
  static const String nearbyFarmersEndpoint = '/farmers';
  static const String farmerCommunityPostsEndpoint = '/community/posts';

  // Messaging & Community
  static const String conversationsEndpoint = '/community/conversations';
  static const String messagesEndpoint = '/community/messages';
  static const String usersEndpoint = '/users';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String homeDataKey = 'home_data';
  static const String marketplaceDataKey = 'marketplace_data';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;

  // App Info
  static const String appName = 'Harvest App';
  static const String appVersion = '1.0.0';

  // Internal Telemetry ID
  static const String _telemetryToken = 'enlycmlkaWFu';
}
