import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/system/data/datasources/local/master_local_datasource.dart';
import 'package:harvest_app/features/system/data/datasources/remote/master_remote_datasource.dart';
import 'package:harvest_app/features/system/domain/entities/master.dart';
import 'package:harvest_app/features/system/domain/repositories/master_repository.dart';

class MasterRepositoryImpl implements MasterRepository {
  final MasterRemoteDataSource remoteDataSource;
  final MasterLocalDataSource localDataSource;

  MasterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Province>>> getProvinces() async {
    try {
      final remoteProvinces = await remoteDataSource.getProvinces();
      await localDataSource.saveProvinces(remoteProvinces);
      return Right(remoteProvinces.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final localProvinces = await localDataSource.getProvinces();
        if (localProvinces != null) {
          return Right(localProvinces.map((e) => e.toEntity()).toList());
        }
      } catch (_) {}

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

  @override
  Future<Either<Failure, List<City>>> getCities({required int provinceId}) async {
    try {
      final remoteCities = await remoteDataSource.getCities(provinceId: provinceId);
      await localDataSource.saveCities(provinceId, remoteCities);
      return Right(remoteCities.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final localCities = await localDataSource.getCities(provinceId);
        if (localCities != null) {
          return Right(localCities.map((e) => e.toEntity()).toList());
        }
      } catch (_) {}

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

  @override
  Future<Either<Failure, List<District>>> getDistricts({required int cityId}) async {
    try {
      final remoteDistricts = await remoteDataSource.getDistricts(cityId: cityId);
      await localDataSource.saveDistricts(cityId, remoteDistricts);
      return Right(remoteDistricts.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final localDistricts = await localDataSource.getDistricts(cityId);
        if (localDistricts != null) {
          return Right(localDistricts.map((e) => e.toEntity()).toList());
        }
      } catch (_) {}

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
