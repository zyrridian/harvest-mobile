import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/sales/domain/entities/cart.dart';
import 'package:harvest_app/features/sales/domain/repositories/cart_repository.dart';

class GetCart {
  final CartRepository repository;

  GetCart(this.repository);

  Future<Either<Failure, Cart>> call() async {
    return repository.getCart();
  }
}
