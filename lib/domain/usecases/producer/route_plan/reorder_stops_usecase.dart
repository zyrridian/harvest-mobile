import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/route_plan.dart';
import 'package:harvest_app/domain/repositories/route_plan_repository.dart';

class ReorderStopsUseCase {
  final RoutePlanRepository repository;

  ReorderStopsUseCase(this.repository);

  Future<Either<Failure, RoutePlan>> call(String routeId, List<String> stopIds) {
    return repository.reorderStops(routeId, stopIds);
  }
}
