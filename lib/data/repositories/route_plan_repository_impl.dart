import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/data/datasources/local/route_plan_local_datasource.dart';
import 'package:harvest_app/data/datasources/remote/route_plan_remote_datasource.dart';
import 'package:harvest_app/domain/entities/route_plan.dart';
import 'package:harvest_app/domain/repositories/route_plan_repository.dart';

class RoutePlanRepositoryImpl implements RoutePlanRepository {
  final RoutePlanRemoteDataSource remoteDataSource;
  final RoutePlanLocalDataSource localDataSource;

  RoutePlanRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<RoutePlan>>> getRoutePlans(String date) async {
    try {
      final remoteRoutePlans = await remoteDataSource.getRoutePlans(date);
      await localDataSource.saveRoutePlans(date, remoteRoutePlans);
      return Right(remoteRoutePlans.map((m) => m.toEntity()).toList());
    } catch (e) {
      try {
        final localRoutePlans = await localDataSource.getRoutePlans(date);
        if (localRoutePlans.isNotEmpty) {
          return Right(localRoutePlans.map((m) => m.toEntity()).toList());
        }
      } catch (_) {}

      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, RoutePlan>> getRoutePlanDetail(String routeId) async {
    try {
      final remoteRoutePlan = await remoteDataSource.getRoutePlanDetail(routeId);
      await localDataSource.saveRoutePlanDetail(remoteRoutePlan);
      return Right(remoteRoutePlan.toEntity());
    } catch (e) {
      try {
        final localRoutePlan = await localDataSource.getRoutePlanDetail(routeId);
        if (localRoutePlan != null) {
          return Right(localRoutePlan.toEntity());
        }
      } catch (_) {}

      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, RoutePlan>> createRoutePlan(String date, List<String> orderIds, bool trackingEnabled) async {
    try {
      final remoteRoutePlan = await remoteDataSource.createRoutePlan(date, orderIds, trackingEnabled);
      // Let's clear the cached list for this date so it fetches fresh next time, or just let it update when refreshed
      return Right(remoteRoutePlan.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  Either<Failure, T> _handleException<T>(dynamic e) {
    if (e is ServerException) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } else if (e is NetworkException) {
      return Left(NetworkFailure(e.message));
    } else if (e is AuthException) {
      return Left(AuthFailure(e.message, statusCode: e.statusCode));
    } else {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }
}
