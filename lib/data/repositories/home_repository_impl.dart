import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/data/datasources/local/home_local_datasource.dart';
import 'package:harvest_app/data/datasources/remote/home_remote_datasource.dart';
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
  Future<Either<Failure, Home>> getHomeData() async {
    try {
      // First try to get home data from local storage
      final localHome = await localDataSource.getHomeData();

      if (localHome != null) {
        return Right(localHome.toEntity());
      }

      // If no local home data, fetch from remote
      final remoteHome = await remoteDataSource.getHomeData();

      // Save to local storage
      await localDataSource.saveHomeData(remoteHome);

      return Right(remoteHome.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }
}
