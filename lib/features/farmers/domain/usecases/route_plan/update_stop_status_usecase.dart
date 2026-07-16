import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/farmers/domain/entities/route_plan.dart';
import 'package:harvest_app/features/farmers/domain/repositories/route_plan_repository.dart';

class UpdateStopStatusUseCase {
  final RoutePlanRepository repository;

  UpdateStopStatusUseCase(this.repository);

  Future<Either<Failure, RouteStop>> call(String routeId, String stopId, String status, {String? notes}) {
    return repository.updateStopStatus(routeId, stopId, status, notes);
  }
}
