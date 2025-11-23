import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/order_repository.dart';

class CancelOrder {
  final OrderRepository repository;

  CancelOrder(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      {required String orderId, required Map<String, dynamic> payload}) async {
    return repository.cancelOrder(orderId: orderId, payload: payload);
  }
}
