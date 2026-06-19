import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/product_detail.dart';
import 'package:harvest_app/domain/entities/favorite_status.dart';
import 'package:harvest_app/domain/entities/review_response.dart';

import 'package:harvest_app/domain/entities/favorite_product.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductDetail>> getProductDetail(String slug);
  Future<Either<Failure, FavoriteStatus>> checkFavoriteStatus(String slug);
  Future<Either<Failure, ReviewResponse>> getProductReviews(String slug,
      {int limit = 5});
  Future<Either<Failure, FavoriteStatus>> addToFavorites(String productId);
  Future<Either<Failure, FavoriteStatus>> removeFromFavorites(String productId);
  Future<Either<Failure, FavoriteProductList>> getUserFavorites();
  Future<Either<Failure, void>> removeFavoriteById(String favoriteId);
}
