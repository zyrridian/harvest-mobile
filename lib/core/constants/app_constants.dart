class AppConstants {
  // API Configuration
  static const String baseUrl =
      'https://mocka.ouim.me/mock'; // Change this to your API URL
  static const String apiVersion = '/api/v1';

  // API Endpoints
  // Auth
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String getCurrentUserEndpoint = '/auth/me';

  // Farmers
  static const String farmersEndpoint = '/11d440e4/api/v1/farmers';
  static const String farmerByIdEndpoint = '/e562710c/api/v1/farmers/:id';
  static const String nearbyFarmersEndpoint = '/f284ffa3/api/v1/farmers/nearby';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';

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
