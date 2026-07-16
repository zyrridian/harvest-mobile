import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/drop_point.dart';
import 'package:harvest_app/features/farmers/domain/repositories/producer_repository.dart';

class UpdateDropPointUseCase {
  final ProducerRepository repository;

  UpdateDropPointUseCase(this.repository);

  Future<Either<Failure, DropPoint>> call(String id, DropPoint dropPoint) async {
    return await repository.updateDropPoint(id, dropPoint);
  }
}
