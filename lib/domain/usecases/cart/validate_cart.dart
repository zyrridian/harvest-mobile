import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/cart_repository.dart';

class ValidateCart {
  final CartRepository repository;

  ValidateCart(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    return repository.validateCart();
  }
}
