import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/drop_point.dart';
import 'package:harvest_app/features/farmers/domain/repositories/producer_repository.dart';

class GetDropPointsUseCase {
  final ProducerRepository repository;

  GetDropPointsUseCase(this.repository);

  Future<Either<Failure, List<DropPoint>>> call() async {
    return await repository.getDropPoints();
  }
}
