/// Base exception class
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Exception thrown when server returns an error
class ServerException extends AppException {
  ServerException(super.message, {super.statusCode});
}

/// Exception thrown when cache operation fails
class CacheException extends AppException {
  CacheException(super.message) : super(statusCode: null);
}

/// Exception thrown when there's no network connection
class NetworkException extends AppException {
  NetworkException(super.message) : super(statusCode: null);
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  AuthException(super.message, {super.statusCode});
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  ValidationException(super.message) : super(statusCode: null);
}
