import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/repositories/harvest_schedule_repository.dart';

class ArrangePickupUseCase {
  final HarvestScheduleRepository repository;

  ArrangePickupUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String harvestId,
    required String pickupTime,
  }) async {
    return await repository.arrangePickup(
      harvestId: harvestId,
      pickupTime: pickupTime,
    );
  }
}
