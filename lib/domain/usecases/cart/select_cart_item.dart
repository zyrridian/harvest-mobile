import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/cart_repository.dart';

class SelectCartItem {
  final CartRepository repository;

  SelectCartItem(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      {required String cartItemId, required bool isSelected}) async {
    return repository.selectItem(
        cartItemId: cartItemId, isSelected: isSelected);
  }
}
