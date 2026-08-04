import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_detail.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_list_response.dart';
import 'package:harvest_app/features/catalog/domain/entities/favorite_status.dart';
import 'package:harvest_app/features/community/domain/entities/review_response.dart';

import 'package:harvest_app/features/catalog/domain/entities/favorite_product.dart';

abstract class ProductRepository {
  /// Product
  Future<Either<Failure, ProductListResponse>> getProducts({
    int? page,
    int? limit,
    String? category,
    String? sellerId,
    bool? isOrganic,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  });
  Future<Either<Failure, ProductDetail>> getProductDetail(String slug);

  /// Product Favorite
  Future<Either<Failure, FavoriteStatus>> checkFavoriteStatus(String slug);
  Future<Either<Failure, FavoriteStatus>> addToFavorites(String productId);
  Future<Either<Failure, FavoriteStatus>> removeFromFavorites(String productId);

  /// Product Review
  Future<Either<Failure, ReviewResponse>> getProductReviews(String slug,
      {int limit = 5});
  Future<Either<Failure, void>> submitProductReview({
    required String productId,
    required String orderId,
    required String title,
    required String content,
    required int rating,
    List<String> images = const [],
  });

  /// Others (TODO: check repository)
  Future<Either<Failure, void>> removeFavoriteById(String favoriteId);
  Future<Either<Failure, FavoriteProductList>> getUserFavorites();
}
