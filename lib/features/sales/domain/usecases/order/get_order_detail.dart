import 'package:dartz/dartz.dart' hide Order;
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/sales/domain/entities/order.dart';
import 'package:harvest_app/features/sales/domain/repositories/order_repository.dart';

class GetOrderDetail {
  final OrderRepository repository;

  GetOrderDetail(this.repository);

  Future<Either<Failure, Order>> call({required String orderId}) async {
    return repository.getOrderDetail(orderId: orderId);
  }
}
