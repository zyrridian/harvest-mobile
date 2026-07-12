import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/farmer_profile.dart';
import 'package:harvest_app/domain/entities/farm_profile_request.dart';
import 'package:harvest_app/domain/repositories/producer_repository.dart';

class UpdateFarmProfileUseCase {
  final ProducerRepository repository;

  UpdateFarmProfileUseCase(this.repository);

  Future<Either<Failure, FarmerProfile>> execute(FarmProfileRequest profile) {
    return repository.updateProfile(profile);
  }
}
