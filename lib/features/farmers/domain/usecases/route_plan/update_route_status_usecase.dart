import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/route_plan.dart';
import 'package:harvest_app/features/farmers/domain/repositories/route_plan_repository.dart';

class UpdateRouteStatusUseCase {
  final RoutePlanRepository repository;

  UpdateRouteStatusUseCase(this.repository);

  Future<Either<Failure, RoutePlan>> call(String routeId, String status) {
    return repository.updateRouteStatus(routeId, status);
  }
}
