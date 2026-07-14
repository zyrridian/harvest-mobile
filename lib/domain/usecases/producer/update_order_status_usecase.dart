import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/producer_repository.dart';

class UpdateOrderStatusUseCase {
  final ProducerRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failure, void>> call(String orderId, String status) {
    return repository.updateOrderStatus(orderId, status);
  }
}
