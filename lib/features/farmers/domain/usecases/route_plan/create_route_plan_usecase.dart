import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/farmers/domain/entities/route_plan.dart';
import 'package:harvest_app/features/farmers/domain/repositories/route_plan_repository.dart';

class CreateRoutePlanUseCase {
  final RoutePlanRepository repository;

  CreateRoutePlanUseCase(this.repository);

  Future<Either<Failure, RoutePlan>> call({
    required String date,
    required List<String> orderIds,
    bool trackingEnabled = true,
  }) {
    return repository.createRoutePlan(date, orderIds, trackingEnabled);
  }
}
