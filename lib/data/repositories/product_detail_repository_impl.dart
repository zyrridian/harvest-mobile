import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/product_detail.dart';
import '../../../domain/repositories/product_detail_repository.dart';
import '../datasources/remote/product_detail_remote_datasource.dart';
import '../models/product_detail_model.dart';

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ProductDetailRemoteDataSource remoteDataSource;

  ProductDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProductDetail>> getProductDetail(
      String productId) async {
    try {
      final result = await remoteDataSource.getProductDetail(productId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String productId) async {
    try {
      await remoteDataSource.addToFavorites(productId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String productId) async {
    try {
      await remoteDataSource.removeFromFavorites(productId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> trackProductView(String productId) async {
    try {
      await remoteDataSource.trackProductView(productId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
