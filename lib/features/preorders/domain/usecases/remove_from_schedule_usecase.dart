import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/repositories/harvest_schedule_repository.dart';

class RemoveFromScheduleUseCase {
  final HarvestScheduleRepository repository;

  RemoveFromScheduleUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String campaignId,
  }) async {
    return await repository.removeFromSchedule(
      campaignId: campaignId,
    );
  }
}
