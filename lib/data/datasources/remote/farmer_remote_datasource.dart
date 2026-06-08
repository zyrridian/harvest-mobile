import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/farmer_model.dart';

abstract class FarmerRemoteDataSource {
  Future<List<FarmerModel>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  });

  Future<FarmerModel> getFarmerById(String id);

  Future<List<FarmerModel>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  });
}

class FarmerRemoteDataSourceImpl implements FarmerRemoteDataSource {
  final Dio dio;

  FarmerRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<FarmerModel>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (query != null) queryParams['query'] = query;
      if (specialties != null && specialties.isNotEmpty) {
        queryParams['specialties'] = specialties.join(',');
      }
      if (hasMapFeature != null) queryParams['has_map_feature'] = hasMapFeature;
      if (maxDistance != null) queryParams['max_distance'] = maxDistance;
      if (minRating != null) queryParams['min_rating'] = minRating;

      final response = await dio.get(
        AppConstants.farmersEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => FarmerModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to fetch farmers',
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
  Future<FarmerModel> getFarmerById(String id) async {
    try {
      final endpoint = AppConstants.farmerByIdEndpoint.replaceAll(':id', id);
      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        return FarmerModel.fromJson(response.data['data'] ?? response.data);
      } else {
        throw ServerException(
          'Failed to fetch farmer',
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
  Future<List<FarmerModel>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    try {
      final response = await dio.get(
        AppConstants.nearbyFarmersEndpoint,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => FarmerModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to fetch nearby farmers',
          statusCode: response.statusCode,
        );
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
