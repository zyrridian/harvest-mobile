import 'package:dartz/dartz.dart' hide Order;
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/order.dart';
import 'package:harvest_app/domain/repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Future<Either<Failure, List<Order>>> call(
      {required String role,
      String? status,
      int page = 1,
      int limit = 20}) async {
    return repository.getOrders(
        role: role, status: status, page: page, limit: limit);
  }
}
