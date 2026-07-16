import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/route_plan.dart';
import 'package:harvest_app/features/farmers/domain/repositories/route_plan_repository.dart';

class GetRoutePlansUseCase {
  final RoutePlanRepository repository;

  GetRoutePlansUseCase(this.repository);

  Future<Either<Failure, List<RoutePlan>>> call(String date) {
    return repository.getRoutePlans(date);
  }
}
