import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/harvest_schedule_dashboard.dart';
import 'package:harvest_app/features/preorders/domain/repositories/harvest_schedule_repository.dart';

class GetHarvestScheduleUseCase {
  final HarvestScheduleRepository repository;

  GetHarvestScheduleUseCase(this.repository);

  Future<Either<Failure, HarvestScheduleDashboardEntity>> call({
    String? month,
  }) async {
    return await repository.getHarvestSchedule(month: month);
  }
}
