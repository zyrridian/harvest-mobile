import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/catalog/data/datasources/remote/product_remote_datasource.dart';
import 'package:harvest_app/features/catalog/data/datasources/local/product_local_datasource.dart';
import 'package:harvest_app/features/catalog/domain/entities/favorite_product.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_detail.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_list_response.dart';
import 'package:harvest_app/features/catalog/domain/entities/favorite_status.dart';
import 'package:harvest_app/features/community/domain/entities/review_response.dart';
import 'package:harvest_app/features/catalog/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ProductListResponse>> getProducts() async {
    try {
      final remoteProducts = await remoteDataSource.getProducts();
      await localDataSource.cacheProducts(remoteProducts);
      return Right(remoteProducts.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ProductDetail>> getProductDetail(String slug) async {
    try {
      final remoteProduct = await remoteDataSource.getProductDetail(slug);
      await localDataSource.cacheProductDetail(remoteProduct);
      return Right(remoteProduct.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FavoriteStatus>> checkFavoriteStatus(
      String slug) async {
    try {
      final result = await remoteDataSource.checkFavoriteStatus(slug);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FavoriteStatus>> addToFavorites(
      String productId) async {
    try {
      final result = await remoteDataSource.addToFavorites(productId);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FavoriteStatus>> removeFromFavorites(
      String productId) async {
    try {
      final result = await remoteDataSource.removeFromFavorites(productId);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ReviewResponse>> getProductReviews(String slug,
      {int limit = 5}) async {
    try {
      final result =
          await remoteDataSource.getProductReviews(slug, limit: limit);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> submitProductReview({
    required String productId,
    required String content,
    required int rating,
    List<String> images = const [],
  }) async {
    try {
      await remoteDataSource.submitProductReview(
        productId: productId,
        content: content,
        rating: rating,
        images: images,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FavoriteProductList>> getUserFavorites() async {
    try {
      final result = await remoteDataSource.getUserFavorites();
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteById(String favoriteId) async {
    try {
      await remoteDataSource.removeFavoriteById(favoriteId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
