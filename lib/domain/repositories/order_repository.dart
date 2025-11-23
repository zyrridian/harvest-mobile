import 'package:dartz/dartz.dart' hide Order;
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<Order>>> getOrders(
      {required String role, String? status, int page = 1, int limit = 20});
  Future<Either<Failure, Order>> getOrderDetail({required String orderId});
  Future<Either<Failure, Map<String, dynamic>>> createOrder(
      {required Map<String, dynamic> payload});
  Future<Either<Failure, Map<String, dynamic>>> cancelOrder(
      {required String orderId, required Map<String, dynamic> payload});
}
