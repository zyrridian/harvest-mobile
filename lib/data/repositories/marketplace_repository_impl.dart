import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/data/datasources/local/marketplace_local_datasource.dart';
import 'package:harvest_app/data/datasources/remote/marketplace_remote_datasource.dart';
import 'package:harvest_app/domain/entities/marketplace.dart';
import 'package:harvest_app/domain/repositories/marketplace_repository.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final MarketplaceRemoteDataSource remoteDataSource;
  final MarketplaceLocalDataSource localDataSource;

  MarketplaceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, MarketplaceResponseEntity>> getMarketplaceData({
    double? latitude,
    double? longitude,
    String? filter,
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final model = await remoteDataSource.getMarketplaceData(
        latitude: latitude,
        longitude: longitude,
        filter: filter,
        search: search,
        page: page,
        limit: limit,
      );
      
      await localDataSource.saveMarketplaceData(model);
      
      return Right(model.toEntity());
    } catch (e) {
      try {
        final localModel = await localDataSource.getMarketplaceData();
        if (localModel != null) {
          return Right(localModel.toEntity());
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

  @override
  Future<Either<Failure, Map<String, dynamic>>> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      final result = await remoteDataSource.addToCart(
        productId: productId,
        quantity: quantity,
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
}
