import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/producer_repository.dart';

class DeleteFarmerProductUseCase {
  final ProducerRepository repository;

  DeleteFarmerProductUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteProduct(id);
  }
}
