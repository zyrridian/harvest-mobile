import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/cart_repository.dart';

class AddCartItem {
  final CartRepository repository;

  AddCartItem(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      {required String productId, required int quantity, String? notes}) async {
    return repository.addItem(
        productId: productId, quantity: quantity, notes: notes);
  }
}
