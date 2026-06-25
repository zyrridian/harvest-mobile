import 'package:dio/dio.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/producer/farmer_stats_model.dart';
import 'package:harvest_app/data/models/producer/farmer_profile_model.dart';
import 'package:harvest_app/data/models/producer/delivery_settings_model.dart';
import 'package:harvest_app/data/models/producer/farmer_product_model.dart';
import 'package:harvest_app/data/models/producer/farmer_order_model.dart';

import 'package:harvest_app/data/models/producer/farmer_product_detail_model.dart';
import 'package:harvest_app/data/models/producer/farm_profile_request_model.dart';
import 'package:harvest_app/data/models/producer/farm_review_model.dart';
import 'package:harvest_app/data/models/producer/drop_point_model.dart';

abstract class ProducerRemoteDataSource {
  Future<FarmerStatsDataModel> getStats();
  Future<FarmerProfileModel> getProfile();
  Future<FarmerProfileModel> updateProfile(FarmProfileRequestModel request);
  Future<DeliverySettingsModel> getDeliverySettings();
  Future<DeliverySettingsModel> updateDeliverySettings(DeliverySettingsModel settings);
  Future<FarmReviewResponseModel> getReviews({int page = 1, int limit = 20});
  Future<List<DropPointModel>> getDropPoints();
  Future<DropPointModel> createDropPoint(DropPointModel dropPoint);
  Future<DropPointModel> updateDropPoint(String id, DropPointModel dropPoint);
  Future<void> deleteDropPoint(String id);
  Future<List<FarmerProductModel>> getProducts({int page = 1, int limit = 20, String? status});
  Future<FarmerProductDetailModel> getProductDetail(String id);
  Future<FarmerProductDetailModel> createProduct(ProductRequestModel product);
  Future<FarmerProductDetailModel> updateProduct(String id, ProductRequestModel product);
  Future<void> deleteProduct(String id);
  Future<void> toggleProductAvailability(String id, bool isAvailable);
  Future<List<FarmerOrderModel>> getOrders({int page = 1, int limit = 20, String status = 'all'});
}

class ProducerRemoteDataSourceImpl implements ProducerRemoteDataSource {
  final Dio dio;

  ProducerRemoteDataSourceImpl(this.dio);

  @override
  Future<FarmerStatsDataModel> getStats() async {
    try {
      final response = await dio.get(AppConstants.producerStatsEndpoint);

      if (response.statusCode == 200) {
        final apiResponse = FarmerStatsResponseModel.fromJson(response.data);
        if (apiResponse.status == 'success') {
          return apiResponse.data;
        } else {
          throw ServerException(
            'Failed to get farmer stats',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Failed to get farmer stats',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<FarmerProfileModel> getProfile() async {
    try {
      final response = await dio.get(AppConstants.producerProfileEndpoint);

      if (response.statusCode == 200) {
        final apiResponse = FarmerProfileResponseModel.fromJson(response.data);
        if (apiResponse.status == 'success') {
          return apiResponse.data;
        } else {
          throw ServerException('Failed to get profile', statusCode: response.statusCode);
        }
      } else {
        throw ServerException('Failed to get profile', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<FarmerProfileModel> updateProfile(FarmProfileRequestModel request) async {
    try {
      final response = await dio.post(AppConstants.producerProfileEndpoint, data: request.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        return FarmerProfileModel.fromJson(data);
      } else {
        throw ServerException('Failed to update profile', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<DeliverySettingsModel> getDeliverySettings() async {
    try {
      final response = await dio.get(AppConstants.producerDeliverySettingsEndpoint);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data['data'] ?? {};
        final Map<String, dynamic> settings = data['delivery_settings'] ?? {};
        return DeliverySettingsModel.fromJson(settings);
      } else {
        throw ServerException('Failed to get delivery settings', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<DeliverySettingsModel> updateDeliverySettings(DeliverySettingsModel settings) async {
    try {
      final response = await dio.put(AppConstants.producerDeliverySettingsEndpoint, data: settings.toJson());

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return DeliverySettingsModel.fromJson(data);
      } else {
        throw ServerException('Failed to update delivery settings', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<FarmReviewResponseModel> getReviews({int page = 1, int limit = 20}) async {
    try {
      final Map<String, dynamic> params = {'page': page, 'limit': limit};
      final response = await dio.get(
        AppConstants.producerReviewsEndpoint,
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return FarmReviewResponseModel.fromJson(data);
      } else {
        throw ServerException('Failed to get reviews', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<DropPointModel>> getDropPoints() async {
    try {
      final response = await dio.get(AppConstants.producerDropPointsEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => DropPointModel.fromJson(e)).toList();
      } else {
        throw ServerException('Failed to get drop points', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<DropPointModel> createDropPoint(DropPointModel dropPoint) async {
    try {
      final response = await dio.post(AppConstants.producerDropPointsEndpoint, data: dropPoint.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        return DropPointModel.fromJson(data);
      } else {
        throw ServerException('Failed to create drop point', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<DropPointModel> updateDropPoint(String id, DropPointModel dropPoint) async {
    try {
      final response = await dio.patch('${AppConstants.producerDropPointsEndpoint}?id=$id', data: dropPoint.toJson());
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return DropPointModel.fromJson(data);
      } else {
        throw ServerException('Failed to update drop point', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deleteDropPoint(String id) async {
    try {
      final response = await dio.delete('${AppConstants.producerDropPointsEndpoint}?id=$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException('Failed to delete drop point', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<FarmerProductModel>> getProducts({int page = 1, int limit = 20, String? status}) async {
    try {
      final Map<String, dynamic> params = {'page': page, 'limit': limit};
      if (status != null && status != 'all') {
        params['status'] = status;
      }
      final response = await dio.get(
        AppConstants.producerProductsEndpoint,
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final apiResponse = FarmerProductResponseModel.fromJson(response.data);
        if (apiResponse.status == 'success') {
          return apiResponse.data;
        } else {
          throw ServerException('Failed to get products', statusCode: response.statusCode);
        }
      } else {
        throw ServerException('Failed to get products', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<FarmerProductDetailModel> getProductDetail(String id) async {
    try {
      final response = await dio.get('${AppConstants.producerProductsEndpoint}/$id');
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return FarmerProductDetailModel.fromJson(data);
      } else {
        throw ServerException('Failed to get product detail', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<FarmerProductDetailModel> createProduct(ProductRequestModel product) async {
    try {
      final response = await dio.post(AppConstants.producerProductsEndpoint, data: product.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        return FarmerProductDetailModel.fromJson(data);
      } else {
        throw ServerException('Failed to create product', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<FarmerProductDetailModel> updateProduct(String id, ProductRequestModel product) async {
    try {
      final response = await dio.put('${AppConstants.producerProductsEndpoint}/$id', data: product.toJson());
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return FarmerProductDetailModel.fromJson(data);
      } else {
        throw ServerException('Failed to update product', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final response = await dio.delete('${AppConstants.producerProductsEndpoint}/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException('Failed to delete product', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> toggleProductAvailability(String id, bool isAvailable) async {
    try {
      final response = await dio.put('${AppConstants.producerProductsEndpoint}/$id', data: {'is_available': isAvailable});
      if (response.statusCode != 200) {
        throw ServerException('Failed to toggle availability', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<FarmerOrderModel>> getOrders({int page = 1, int limit = 20, String status = 'all'}) async {
    try {
      final response = await dio.get(
        AppConstants.producerOrdersEndpoint,
        queryParameters: {'page': page, 'limit': limit, 'status': status},
      );

      if (response.statusCode == 200) {
        // Mocking the structure based on standard responses for now
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => FarmerOrderModel.fromJson(e)).toList();
      } else {
        throw ServerException('Failed to get orders', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  ServerException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException('Connection timeout. Please try again.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Server error occurred';

        if (statusCode == 401) {
          throw AuthException(message, statusCode: statusCode);
        }
        throw ServerException(message, statusCode: statusCode);

      case DioExceptionType.cancel:
        throw ServerException('Request cancelled');

      case DioExceptionType.unknown:
        throw NetworkException('No internet connection');

      default:
        throw ServerException('An unexpected error occurred');
    }
  }
}
