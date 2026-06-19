import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/product_detail_model.dart';
import 'package:harvest_app/data/models/favorite_status_model.dart';
import 'package:harvest_app/data/models/review_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductDetailModel> getProductDetail(String slug);
  Future<FavoriteStatusModel> checkFavoriteStatus(String slug);
  Future<ReviewResponseModel> getProductReviews(String slug, {int limit = 5});
  Future<FavoriteStatusModel> addToFavorites(String productId);
  Future<FavoriteStatusModel> removeFromFavorites(String productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<ProductDetailModel> getProductDetail(String slug) async {
    try {
      final response = await dio.get('/products/$slug');
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
      final response = await dio.get('/products/$slug/favorite');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return FavoriteStatusModel.fromJson(response.data['data']);
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
        '/reviews/$slug',
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
      final response = await dio.post('/products/$productId/favorite');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return FavoriteStatusModel.fromJson(response.data['data']);
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
      final response = await dio.delete('/products/$productId/favorite');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return FavoriteStatusModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to remove from favorites');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }
}
