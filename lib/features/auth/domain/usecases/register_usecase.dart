import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/auth/domain/entities/user.dart';
import 'package:harvest_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String name,
    required String userType,
    String? phoneNumber,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      name: name,
      userType: userType,
      phoneNumber: phoneNumber,
    );
  }
}
