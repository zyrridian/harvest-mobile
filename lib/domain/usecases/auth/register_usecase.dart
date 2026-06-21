import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

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
