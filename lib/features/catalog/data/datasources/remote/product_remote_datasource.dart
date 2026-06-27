import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/catalog/data/models/product/product_detail_model.dart';
import 'package:harvest_app/features/catalog/data/models/product/favorite_status_model.dart';
import 'package:harvest_app/features/catalog/data/models/product/review_response_model.dart';
import 'package:harvest_app/features/catalog/data/models/product/favorite_product_model.dart';

import 'package:harvest_app/features/catalog/data/models/product/product_list_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductListResponseModel> getProducts();
  Future<ProductDetailModel> getProductDetail(String slug);
  Future<FavoriteStatusModel> checkFavoriteStatus(String slug);
  Future<ReviewResponseModel> getProductReviews(String slug, {int limit = 5});
  Future<FavoriteStatusModel> addToFavorites(String productId);
  Future<FavoriteStatusModel> removeFromFavorites(String productId);
  Future<FavoriteProductListModel> getUserFavorites();
  Future<void> removeFavoriteById(String favoriteId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<ProductListResponseModel> getProducts() async {
    try {
      final response = await dio.get('/catalog/products');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return ProductListResponseModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to get products');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<ProductDetailModel> getProductDetail(String slug) async {
    try {
      final response = await dio.get('/catalog/products/$slug');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return ProductDetailModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to get product detail');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<FavoriteStatusModel> checkFavoriteStatus(String slug) async {
    try {
      final response = await dio.get('/catalog/products/$slug/favorite');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final data = response.data['data'];
        return FavoriteStatusModel(
          productId: slug,
          isFavorited: data['checked'] ?? data['is_favorited'] ?? false,
        );
      } else {
        throw ServerException('Failed to get favorite status');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<ReviewResponseModel> getProductReviews(String slug,
      {int limit = 5}) async {
    try {
      final response = await dio.get(
        '/catalog/products/reviews/$slug',
        queryParameters: {'limit': limit},
      );
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return ReviewResponseModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to get reviews');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<FavoriteStatusModel> addToFavorites(String productId) async {
    try {
      final response = await dio.post('/catalog/products/$productId/favorite');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final data = response.data['data'];
        return FavoriteStatusModel(
          productId: productId,
          isFavorited: data['checked'] ?? data['is_favorited'] ?? true,
        );
      } else {
        throw ServerException('Failed to add to favorites');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<FavoriteStatusModel> removeFromFavorites(String productId) async {
    try {
      final response = await dio.delete('/catalog/products/$productId/favorite');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final data = response.data['data'];
        return FavoriteStatusModel(
          productId: productId,
          isFavorited: data['checked'] ?? data['is_favorited'] ?? false,
        );
      } else {
        throw ServerException('Failed to remove from favorites');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<FavoriteProductListModel> getUserFavorites() async {
    try {
      final response = await dio.get('/users/favorites');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final data = response.data['data'];
        if (data is List) {
          final favorites = data
              .map((e) =>
                  FavoriteProductModel.fromJson(e as Map<String, dynamic>))
              .toList();
          return FavoriteProductListModel(
              favorites: favorites, total: favorites.length);
        } else if (data is Map<String, dynamic>) {
          return FavoriteProductListModel.fromJson(data);
        } else {
          return FavoriteProductListModel(favorites: [], total: 0);
        }
      } else {
        throw ServerException('Failed to get favorites');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> removeFavoriteById(String favoriteId) async {
    try {
      final response = await dio.delete('/users/favorites/$favoriteId');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return;
      } else {
        throw ServerException('Failed to remove favorite');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }
}
