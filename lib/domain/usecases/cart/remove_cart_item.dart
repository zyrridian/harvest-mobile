import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/cart_repository.dart';

class RemoveCartItem {
  final CartRepository repository;

  RemoveCartItem(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      {required String cartItemId}) async {
    return repository.removeItem(cartItemId: cartItemId);
  }
}
