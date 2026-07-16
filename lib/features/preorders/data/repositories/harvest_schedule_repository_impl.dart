import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/data/datasources/remote/harvest_schedule_remote_datasource.dart';
import 'package:harvest_app/features/preorders/domain/entities/harvest_schedule_dashboard.dart';
import 'package:harvest_app/features/preorders/domain/repositories/harvest_schedule_repository.dart';

class HarvestScheduleRepositoryImpl implements HarvestScheduleRepository {
  final HarvestScheduleRemoteDataSource remoteDataSource;

  HarvestScheduleRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, HarvestScheduleDashboardEntity>> getHarvestSchedule({
    String? month,
  }) async {
    try {
      final model = await remoteDataSource.getHarvestSchedule(month: month);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> payDeposit({
    required String harvestId,
  }) async {
    try {
      final result = await remoteDataSource.payDeposit(harvestId: harvestId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> arrangePickup({
    required String harvestId,
    required String pickupTime,
  }) async {
    try {
      final result = await remoteDataSource.arrangePickup(
        harvestId: harvestId,
        pickupTime: pickupTime,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HarvestScheduleDashboardEntity>> getScheduleDashboard({
    String? month,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final result = await remoteDataSource.getScheduleDashboard(
        month: month,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
