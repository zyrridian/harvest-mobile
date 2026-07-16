import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/explore.dart';
import 'package:harvest_app/features/explore/domain/repositories/explore_repository.dart';

class GetExploreDataUseCase {
  final ExploreRepository repository;

  GetExploreDataUseCase(this.repository);

  Future<Either<Failure, Explore>> execute() {
    return repository.getExploreData();
  }
}
