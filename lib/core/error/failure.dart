import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failures related to server communication
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

/// Failures related to local cache
class CacheFailure extends Failure {
  const CacheFailure(super.message) : super(statusCode: null);
}

/// Failures related to network connectivity
class NetworkFailure extends Failure {
  const NetworkFailure(super.message) : super(statusCode: null);
}

/// Failures related to authentication
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.statusCode});
}

/// Failures related to validation
class ValidationFailure extends Failure {
  const ValidationFailure(super.message) : super(statusCode: null);
}

/// Generic failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message) : super(statusCode: null);
}
