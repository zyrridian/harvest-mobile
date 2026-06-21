import 'package:dio/dio.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/producer/farmer_stats_model.dart';
import 'package:harvest_app/data/models/producer/farmer_profile_model.dart';
import 'package:harvest_app/data/models/producer/delivery_settings_model.dart';
import 'package:harvest_app/data/models/producer/farmer_product_model.dart';
import 'package:harvest_app/data/models/producer/farmer_order_model.dart';

abstract class ProducerRemoteDataSource {
  Future<FarmerStatsDataModel> getStats();
  Future<FarmerProfileModel> getProfile();
  Future<DeliverySettingsModel> getDeliverySettings();
  Future<List<FarmerProductModel>> getProducts({int page = 1, int limit = 20});
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
  Future<List<FarmerProductModel>> getProducts({int page = 1, int limit = 20}) async {
    try {
      final response = await dio.get(
        AppConstants.producerProductsEndpoint,
        queryParameters: {'page': page, 'limit': limit},
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
