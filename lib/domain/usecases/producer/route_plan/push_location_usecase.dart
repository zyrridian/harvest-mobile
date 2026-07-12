import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/repositories/route_plan_repository.dart';

class PushLocationUseCase {
  final RoutePlanRepository repository;

  PushLocationUseCase(this.repository);

  Future<Either<Failure, void>> call(String routeId, double lat, double lng, {double? accuracy}) {
    return repository.pushLocation(routeId, lat, lng, accuracy);
  }
}
