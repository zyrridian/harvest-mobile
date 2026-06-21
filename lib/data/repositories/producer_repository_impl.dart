import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/data/datasources/remote/producer_remote_datasource.dart';
import 'package:harvest_app/domain/entities/farmer_stats.dart';
import 'package:harvest_app/domain/entities/farmer_profile.dart';
import 'package:harvest_app/domain/entities/delivery_settings.dart';
import 'package:harvest_app/domain/entities/farmer_product.dart';
import 'package:harvest_app/domain/entities/farmer_order.dart';
import 'package:harvest_app/domain/repositories/producer_repository.dart';

class ProducerRepositoryImpl implements ProducerRepository {
  final ProducerRemoteDataSource remoteDataSource;

  ProducerRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, FarmerStats>> getStats() async {
    try {
      final model = await remoteDataSource.getStats();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FarmerProfile>> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeliverySettings>> getDeliverySettings() async {
    try {
      final model = await remoteDataSource.getDeliverySettings();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FarmerProduct>>> getProducts({int page = 1, int limit = 20}) async {
    try {
      final models = await remoteDataSource.getProducts(page: page, limit: limit);
      return Right(models.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FarmerOrder>>> getOrders({int page = 1, int limit = 20, String status = 'all'}) async {
    try {
      final models = await remoteDataSource.getOrders(page: page, limit: limit, status: status);
      return Right(models.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
