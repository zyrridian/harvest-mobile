import 'package:dartz/dartz.dart' hide Order;
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/data/datasources/remote/order_remote_datasource.dart';
import 'package:harvest_app/domain/entities/order.dart';
import 'package:harvest_app/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remote;

  OrderRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<Order>>> getOrders(
      {required String role,
      String? status,
      int page = 1,
      int limit = 20}) async {
    try {
      final models = await remote.getOrders(
          role: role, status: status, page: page, limit: limit);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderDetail(
      {required String orderId}) async {
    try {
      final model = await remote.getOrderDetail(orderId: orderId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createOrder(
      {required Map<String, dynamic> payload}) async {
    try {
      final res = await remote.createOrder(payload: payload);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> cancelOrder(
      {required String orderId, required Map<String, dynamic> payload}) async {
    try {
      final res = await remote.cancelOrder(orderId: orderId, payload: payload);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
