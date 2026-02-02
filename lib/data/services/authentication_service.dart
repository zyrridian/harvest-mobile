import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Authentication service for handling all auth-related API calls
class AuthenticationService {
  final Dio _dio;
  final SecureStorageService _storageService;

  AuthenticationService(this._dio, this._storageService);

  /// Login with email and password
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = AuthApiResponse.fromJson(response.data);

        if (apiResponse.isSuccess && apiResponse.data != null) {
          final authData = apiResponse.data!;

          // Save tokens and user data
          await _saveAuthData(authData);

          return authData;
        } else {
          throw AuthException(
            apiResponse.message ?? 'Login failed',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  /// Register a new user
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.registerEndpoint,
        data: {
          'email': email,
          'password': password,
          'name': name,
          if (phoneNumber != null && phoneNumber.isNotEmpty)
            'phone_number': phoneNumber,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = AuthApiResponse.fromJson(response.data);

        if (apiResponse.isSuccess && apiResponse.data != null) {
          final authData = apiResponse.data!;

          // Save tokens and user data
          await _saveAuthData(authData);

          return authData;
        } else {
          throw AuthException(
            apiResponse.message ?? 'Registration failed',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    try {
      await _dio.post(AppConstants.logoutEndpoint);
    } catch (e) {
      // Ignore logout errors, we'll clear local data anyway
    } finally {
      // Always clear local auth data
      await _storageService.clearAuthData();
    }
  }

  /// Get current user info
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get(AppConstants.getCurrentUserEndpoint);

      if (response.statusCode == 200) {
        final apiResponse = UserInfoResponse.fromJson(response.data);

        if (apiResponse.isSuccess && apiResponse.data != null) {
          // Update stored user data
          await _storageService.saveUserData(apiResponse.data!);
          return apiResponse.data!;
        } else {
          throw AuthException(
            apiResponse.message ?? 'Failed to get user info',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Failed to get current user',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  /// Refresh the access token using refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();

      if (refreshToken == null) {
        return false;
      }

      final response = await _dio.post(
        AppConstants.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final apiResponse = TokenRefreshResponse.fromJson(response.data);

        if (apiResponse.isSuccess && apiResponse.data != null) {
          final tokenData = apiResponse.data!;

          // Save new tokens
          await _storageService.saveAccessToken(tokenData.accessToken);
          if (tokenData.refreshToken != null) {
            await _storageService.saveRefreshToken(tokenData.refreshToken!);
          }
          await _storageService.saveTokenExpiry(tokenData.tokenExpiryTime);

          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final isLoggedIn = await _storageService.isLoggedIn();
    if (!isLoggedIn) return false;

    final token = await _storageService.getAccessToken();
    if (token == null) return false;

    // Check if token is expired
    final isExpired = await _storageService.isTokenExpired();
    if (isExpired) {
      // Try to refresh
      return await refreshToken();
    }

    return true;
  }

  /// Get stored user data
  Future<UserModel?> getStoredUser() async {
    return await _storageService.getUserData();
  }

  /// Save auth data to secure storage
  Future<void> _saveAuthData(AuthResponseModel authData) async {
    await _storageService.saveAccessToken(authData.accessToken);

    if (authData.refreshToken != null) {
      await _storageService.saveRefreshToken(authData.refreshToken!);
    }

    await _storageService.saveTokenExpiry(authData.tokenExpiryTime);
    await _storageService.saveUserData(authData.user);
    await _storageService.setLoggedIn(true);
  }

  /// Handle Dio exceptions
  AppException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please try again.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        String message = 'Server error occurred';

        // Try to extract message from response
        if (e.response?.data is Map) {
          message = e.response?.data['message'] ?? message;
        }

        if (statusCode == 401) {
          return AuthException(message, statusCode: statusCode);
        }
        if (statusCode == 400) {
          return ValidationException(message);
        }
        return ServerException(message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return ServerException('Request cancelled');

      case DioExceptionType.unknown:
        if (e.error != null && e.error.toString().contains('SocketException')) {
          return NetworkException('No internet connection');
        }
        return NetworkException('Connection error. Please check your network.');

      default:
        return ServerException('An unexpected error occurred');
    }
  }
}

/// Provider for AuthenticationService
final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  final dio = ref.watch(dioProvider);
  final storageService = ref.watch(secureStorageServiceProvider);

  return AuthenticationService(dio, storageService);
});
