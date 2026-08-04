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

  @override
  Future<Either<Failure, void>> addToSchedule({
    required String campaignId,
    bool remindersEnabled = true,
  }) async {
    try {
      await remoteDataSource.addToSchedule(
        campaignId: campaignId,
        remindersEnabled: remindersEnabled,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromSchedule({
    required String campaignId,
  }) async {
    try {
      await remoteDataSource.removeFromSchedule(campaignId: campaignId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
