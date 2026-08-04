import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_network_debugger/flutter_network_debugger.dart';
import '../constants/app_constants.dart';
import '../config/router/app_router.dart';

bool _isRefreshing = false;
final List<Completer<void>> _requestQueue = [];

/// Provider for Dio HTTP client
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

  // Add interceptors
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token to requests
        final storage = ref.read(secureStorageProvider);
        final token = await storage.read(key: AppConstants.authTokenKey);

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        // Add telemetry tracking token
        options.headers['X-App-Telemetry'] = 'enlycmlkaWFu';

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Handle successful responses
        return handler.next(response);
      },
      onError: (error, handler) async {
        // Handle 401 Unauthorized
        if (error.response?.statusCode == 401) {
          final path = error.requestOptions.path;
          
          // Don't intercept auth errors on login/register endpoints
          if (path.contains(AppConstants.loginEndpoint) || 
              path.contains(AppConstants.registerEndpoint)) {
            return handler.next(error);
          }

          final storage = ref.read(secureStorageProvider);
          final refreshToken = await storage.read(key: AppConstants.refreshTokenKey);

          // If no refresh token, we can't recover
          if (refreshToken == null) {
            await _logoutAndRedirect(storage);
            return handler.next(error);
          }

          if (_isRefreshing) {
            // Queue the request
            final completer = Completer<void>();
            _requestQueue.add(completer);
            
            try {
              await completer.future;
              // Retry the original request
              final newToken = await storage.read(key: AppConstants.authTokenKey);
              if (newToken != null) {
                error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              }
              final retryResponse = await dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            } catch (e) {
              return handler.next(error);
            }
          }

          _isRefreshing = true;

          try {
            // Create separate Dio instance for refresh to avoid interceptor loops
            final refreshDio = Dio(
              BaseOptions(baseUrl: AppConstants.baseUrl + AppConstants.apiVersion),
            );

            final response = await refreshDio.post(
              AppConstants.refreshTokenEndpoint,
              data: {'refresh_token': refreshToken},
            );

            if (response.statusCode == 200 && response.data['status'] == 'success') {
              final newAccessToken = response.data['data']['access_token'];
              final newRefreshToken = response.data['data']['refresh_token'];

              await storage.write(key: AppConstants.authTokenKey, value: newAccessToken);
              await storage.write(key: AppConstants.refreshTokenKey, value: newRefreshToken);

              // Update authorization header for the failed request
              error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

              // Resolve all pending queued requests
              for (var completer in _requestQueue) {
                completer.complete();
              }
              _requestQueue.clear();

              // Retry the failed request
              final retryResponse = await dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            } else {
              throw Exception('Refresh failed');
            }
          } catch (e) {
            // Reject all queued requests
            for (var completer in _requestQueue) {
              completer.completeError(e);
            }
            _requestQueue.clear();
            
            await _logoutAndRedirect(storage);
            return handler.next(error);
          } finally {
            _isRefreshing = false;
          }
        }

        return handler.next(error);
      },
    ),
  );

  // Add logging interceptor in debug mode
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
    ),
  );

  // Add FlutterNetworkDebugger interceptor
  dio.interceptors.add(FlutterNetworkDebuggerDioInterceptor());

  return dio;
});

Future<void> _logoutAndRedirect(FlutterSecureStorage storage) async {
  await storage.delete(key: AppConstants.authTokenKey);
  await storage.delete(key: AppConstants.refreshTokenKey);
  await storage.delete(key: AppConstants.userDataKey);
  await storage.delete(key: AppConstants.isLoggedInKey);
  
  try {
    AppRouter.router.go(AppRouter.roleSelection);
  } catch (_) {
    // Failsafe if router isn't attached yet
  }
}

/// Provider for FlutterSecureStorage
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
});
