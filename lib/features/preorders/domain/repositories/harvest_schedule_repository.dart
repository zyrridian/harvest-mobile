import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/entities/harvest_schedule_dashboard.dart';

abstract class HarvestScheduleRepository {
  Future<Either<Failure, HarvestScheduleDashboardEntity>> getScheduleDashboard({
    String? month,
    double? latitude,
    double? longitude,
  });

  Future<Either<Failure, void>> addToSchedule({
    required String campaignId,
    bool remindersEnabled = true,
  });

  Future<Either<Failure, void>> removeFromSchedule({
    required String campaignId,
  });
}
