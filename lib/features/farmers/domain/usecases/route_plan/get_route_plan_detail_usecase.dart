import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/route_plan.dart';
import 'package:harvest_app/features/farmers/domain/repositories/route_plan_repository.dart';

class GetRoutePlanDetailUseCase {
  final RoutePlanRepository repository;

  GetRoutePlanDetailUseCase(this.repository);

  Future<Either<Failure, RoutePlan>> call(String routeId) {
    return repository.getRoutePlanDetail(routeId);
  }
}
