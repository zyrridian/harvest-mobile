import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/cart_repository.dart';

class UpdateCartItem {
  final CartRepository repository;

  UpdateCartItem(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      {required String cartItemId,
      required int quantity,
      String? notes}) async {
    return repository.updateItem(
        cartItemId: cartItemId, quantity: quantity, notes: notes);
  }
}
