import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/user.dart';

abstract class AuthRepository {
  /// Login user with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    required String userType,
    String? phoneNumber,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current logged in user
  Future<Either<Failure, User>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Refresh authentication token
  Future<Either<Failure, void>> refreshToken();
}
