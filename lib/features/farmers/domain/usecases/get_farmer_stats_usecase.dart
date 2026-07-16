import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/farmer_stats.dart';
import 'package:harvest_app/features/farmers/domain/repositories/producer_repository.dart';

class GetFarmerStatsUseCase {
  final ProducerRepository repository;

  GetFarmerStatsUseCase(this.repository);

  Future<Either<Failure, FarmerStats>> call() async {
    return await repository.getStats();
  }
}
