import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/repositories/harvest_schedule_repository.dart';

class AddToScheduleUseCase {
  final HarvestScheduleRepository repository;

  AddToScheduleUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String campaignId,
    bool remindersEnabled = true,
  }) async {
    return await repository.addToSchedule(
      campaignId: campaignId,
      remindersEnabled: remindersEnabled,
    );
  }
}
