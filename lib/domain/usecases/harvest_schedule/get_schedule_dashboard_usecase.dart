import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/harvest_schedule_repository.dart';

class GetScheduleDashboardUseCase {
  final HarvestScheduleRepository repository;

  GetScheduleDashboardUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    String? month,
    double? latitude,
    double? longitude,
  }) {
    return repository.getScheduleDashboard(
      month: month,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
