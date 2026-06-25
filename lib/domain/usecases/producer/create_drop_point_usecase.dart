import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/drop_point.dart';
import 'package:harvest_app/domain/repositories/producer_repository.dart';

class CreateDropPointUseCase {
  final ProducerRepository repository;

  CreateDropPointUseCase(this.repository);

  Future<Either<Failure, DropPoint>> call(DropPoint dropPoint) async {
    return await repository.createDropPoint(dropPoint);
  }
}
