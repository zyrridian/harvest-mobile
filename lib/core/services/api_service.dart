import 'package:dio/dio.dart';
import 'package:dio_network_logger/dio_network_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/app_constants.dart';
import 'storage_service.dart';

/// Base API service with Dio configuration and interceptors
class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Dio get dio => _dio;

  /// Make a GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Make a POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Make a PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Make a PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Make a DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

/// Token refresh callback type
typedef TokenRefreshCallback = Future<bool> Function();

/// Auth interceptor for handling token refresh
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;
  final Dio _dio;
  TokenRefreshCallback? _onTokenRefresh;
  bool _isRefreshing = false;

  AuthInterceptor(this._storageService, this._dio);

  void setTokenRefreshCallback(TokenRefreshCallback callback) {
    _onTokenRefresh = callback;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Always add token for logout and getCurrentUser endpoints
    final needsAuth = options.path.contains('/auth/logout') ||
        options.path.contains('/auth/me');

    // Skip auth header for login, register, and refresh endpoints
    final skipAuth = options.path.contains('/auth/login') ||
        options.path.contains('/auth/register') ||
        options.path.contains('/auth/refresh');

    if (needsAuth || !skipAuth && !options.path.contains('/auth/')) {
      final token = await _storageService.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      // Don't try to refresh if we're on auth endpoints
      if (err.requestOptions.path.contains('/auth/login') ||
          err.requestOptions.path.contains('/auth/register') ||
          err.requestOptions.path.contains('/auth/refresh')) {
        return handler.next(err);
      }

      _isRefreshing = true;

      try {
        // Try to refresh token
        if (_onTokenRefresh != null) {
          final refreshed = await _onTokenRefresh!();

          if (refreshed) {
            // Retry the original request with new token
            final token = await _storageService.getAccessToken();
            err.requestOptions.headers['Authorization'] = 'Bearer $token';

            final response = await _dio.fetch(err.requestOptions);
            _isRefreshing = false;
            return handler.resolve(response);
          }
        }
      } catch (e) {
        _isRefreshing = false;
        // Token refresh failed, clear auth data
        await _storageService.clearAuthData();
      }

      _isRefreshing = false;
    }

    handler.next(err);
  }
}

/// Provider for configured Dio instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add network logger in debug mode
  if (kDebugMode) {
    dio.interceptors.add(DioNetworkLogger());
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  return dio;
});

/// Provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  final storageService = ref.watch(secureStorageServiceProvider);

  // Create auth interceptor
  final authInterceptor = AuthInterceptor(storageService, dio);
  dio.interceptors.insert(0, authInterceptor);

  return ApiService(dio);
});

/// Provider for AuthInterceptor (to set token refresh callback later)
final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  final dio = ref.watch(dioProvider);
  final storageService = ref.watch(secureStorageServiceProvider);

  // Find or create auth interceptor
  AuthInterceptor? existing;
  for (final interceptor in dio.interceptors) {
    if (interceptor is AuthInterceptor) {
      existing = interceptor;
      break;
    }
  }

  if (existing != null) {
    return existing;
  }

  final authInterceptor = AuthInterceptor(storageService, dio);
  dio.interceptors.insert(0, authInterceptor);
  return authInterceptor;
});
