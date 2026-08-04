import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/farmers/domain/repositories/producer_repository.dart';

class ToggleFarmerProductAvailabilityUseCase {
  final ProducerRepository repository;

  ToggleFarmerProductAvailabilityUseCase(this.repository);

  Future<Either<Failure, void>> call(String id, bool isAvailable) async {
    return await repository.toggleProductAvailability(id, isAvailable);
  }
}
