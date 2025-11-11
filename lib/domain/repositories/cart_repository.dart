import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, Map<String, dynamic>>> addItem(
      {required String productId, required int quantity, String? notes});
  Future<Either<Failure, Map<String, dynamic>>> updateItem(
      {required String cartItemId, required int quantity, String? notes});
  Future<Either<Failure, Map<String, dynamic>>> removeItem(
      {required String cartItemId});
  Future<Either<Failure, Map<String, dynamic>>> selectItem(
      {required String cartItemId, required bool isSelected});
  Future<Either<Failure, Map<String, dynamic>>> clearCart();
  Future<Either<Failure, Map<String, dynamic>>> validateCart();
}
