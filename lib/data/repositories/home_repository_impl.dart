import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/storefront/data/datasources/local/home_local_datasource.dart';
import 'package:harvest_app/features/storefront/data/datasources/remote/home_remote_datasource.dart';
import 'package:harvest_app/domain/entities/home.dart';
import 'package:harvest_app/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Home>> getHomeData({
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      // Always try to fetch fresh data from remote first
      final remoteHome = await remoteDataSource.getHomeData(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );

      // Save to local storage for offline fallback
      await localDataSource.saveHomeData(remoteHome);

      return Right(remoteHome.toEntity());
    } catch (e) {
      // If remote fails (e.g. no internet), try to get from local cache
      try {
        final localHome = await localDataSource.getHomeData();
        if (localHome != null) {
          return Right(localHome.toEntity());
        }
      } catch (_) {
        // Ignore local cache error, handle the remote error below
      }

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
}
