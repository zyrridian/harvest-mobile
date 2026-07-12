import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/route_plan.dart';

abstract class RoutePlanRepository {
  Future<Either<Failure, List<RoutePlan>>> getRoutePlans(String date);
  Future<Either<Failure, RoutePlan>> getRoutePlanDetail(String routeId);
  Future<Either<Failure, RoutePlan>> createRoutePlan(
      String date, List<String> orderIds, bool trackingEnabled);
  Future<Either<Failure, RoutePlan>> updateRouteStatus(String routeId, String status);
  Future<Either<Failure, RouteStop>> updateStopStatus(String routeId, String stopId, String status, String? notes);
  Future<Either<Failure, RoutePlan>> reorderStops(String routeId, List<String> stopIds);
  Future<Either<Failure, void>> pushLocation(String routeId, double lat, double lng, double? accuracy);
}
