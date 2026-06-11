import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/farmer_model.dart';
import '../../models/paginated_response_model.dart';

abstract class FarmerRemoteDataSource {
  Future<PaginatedResponseModel<FarmerModel>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
    int? limit,
    int? page,
    String? sortBy,
    double? latitude,
    double? longitude,
  });

  Future<FarmerModel> getFarmerById(String id);

  Future<PaginatedResponseModel<FarmerModel>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    int? limit,
    int? page,
  });
}

class FarmerRemoteDataSourceImpl implements FarmerRemoteDataSource {
  final Dio dio;

  FarmerRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaginatedResponseModel<FarmerModel>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
    int? limit,
    int? page,
    String? sortBy,
    double? latitude,
    double? longitude,
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
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;

      final response = await dio.get(
        AppConstants.farmersEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return PaginatedResponseModel.fromJson(
          response.data,
          (json) => FarmerModel.fromJson(json),
        );
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
        final responseData = response.data;
        final data = responseData is Map<String, dynamic> &&
                responseData.containsKey('data')
            ? responseData['data']
            : responseData;
        return FarmerModel.fromJson(data as Map<String, dynamic>);
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
  Future<PaginatedResponseModel<FarmerModel>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    int? limit,
    int? page,
  }) async {
    try {
      // Using the main farmers endpoint with coordinates
      return await getFarmers(
        latitude: latitude,
        longitude: longitude,
        maxDistance: radius,
        limit: limit,
        page: page,
      );
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
