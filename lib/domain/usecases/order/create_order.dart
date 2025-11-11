import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/order_repository.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      {required Map<String, dynamic> payload}) async {
    return repository.createOrder(payload: payload);
  }
}
