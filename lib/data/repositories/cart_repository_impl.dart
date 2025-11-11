import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/data/datasources/remote/cart_remote_datasource.dart';
import 'package:harvest_app/domain/entities/cart.dart';
import 'package:harvest_app/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remote;

  CartRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, Cart>> getCart() async {
    try {
      final model = await remote.getCart();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addItem(
      {required String productId, required int quantity, String? notes}) async {
    try {
      final res = await remote.addItem(
          productId: productId, quantity: quantity, notes: notes);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateItem(
      {required String cartItemId,
      required int quantity,
      String? notes}) async {
    try {
      final res = await remote.updateItem(
          cartItemId: cartItemId, quantity: quantity, notes: notes);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> removeItem(
      {required String cartItemId}) async {
    try {
      final res = await remote.removeItem(cartItemId: cartItemId);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> selectItem(
      {required String cartItemId, required bool isSelected}) async {
    try {
      final res = await remote.selectItem(
          cartItemId: cartItemId, isSelected: isSelected);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> clearCart() async {
    try {
      final res = await remote.clearCart();
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> validateCart() async {
    try {
      final res = await remote.validateCart();
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
