class AppConstants {
  // Image Placeholders
  static const String placeholderImage =
      'https://picsum.photos/400/400';

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
  static const String getHomeDataEndpoint = '/home';

  // Farmers
  static const String farmersEndpoint = '/farmers';
  static const String farmerByIdEndpoint = '/farmers/:id';
  static const String farmerProductsEndpoint = '/farmers/:id/products';
  static const String farmerReviewsEndpoint = '/farmers/:id/reviews';
  static const String nearbyFarmersEndpoint = '/farmers';
  static const String farmerCommunityPostsEndpoint = '/community/posts';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String homeDataKey = 'home_data';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;

  // App Info
  static const String appName = 'Harvest App';
  static const String appVersion = '1.0.0';
}
