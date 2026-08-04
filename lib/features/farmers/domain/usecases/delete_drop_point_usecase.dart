import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/farmers/domain/repositories/producer_repository.dart';

class DeleteDropPointUseCase {
  final ProducerRepository repository;

  DeleteDropPointUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteDropPoint(id);
  }
}
