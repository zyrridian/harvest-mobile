import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/entities/harvest_schedule_dashboard.dart';

abstract class HarvestScheduleRepository {
  Future<Either<Failure, HarvestScheduleDashboardEntity>> getHarvestSchedule({
    String? month,
  });

  Future<Either<Failure, Map<String, dynamic>>> payDeposit({
    required String harvestId,
  });

  Future<Either<Failure, Map<String, dynamic>>> arrangePickup({
    required String harvestId,
    required String pickupTime,
  });

  Future<Either<Failure, HarvestScheduleDashboardEntity>> getScheduleDashboard({
    String? month,
    double? latitude,
    double? longitude,
  });
}
