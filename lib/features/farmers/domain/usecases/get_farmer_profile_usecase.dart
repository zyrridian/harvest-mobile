import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/farmer_profile.dart';
import 'package:harvest_app/features/farmers/domain/repositories/producer_repository.dart';

class GetFarmerProfileUseCase {
  final ProducerRepository repository;

  GetFarmerProfileUseCase(this.repository);

  Future<Either<Failure, FarmerProfile>> call() async {
    return await repository.getProfile();
  }
}
