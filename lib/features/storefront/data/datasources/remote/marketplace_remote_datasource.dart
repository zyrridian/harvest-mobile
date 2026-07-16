import 'package:dio/dio.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/storefront/data/models/marketplace_model.dart';
import 'package:harvest_app/features/storefront/data/models/marketplace_response_model.dart';

abstract class MarketplaceRemoteDataSource {
  Future<MarketplaceModel> getMarketplaceData({
    double? latitude,
    double? longitude,
    String? filter,
    String? search,
    int? page,
    int? limit,
  });

  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
  });
}

class MarketplaceRemoteDataSourceImpl implements MarketplaceRemoteDataSource {
  final Dio dio;

  MarketplaceRemoteDataSourceImpl(this.dio);

  @override
  Future<MarketplaceModel> getMarketplaceData({
    double? latitude,
    double? longitude,
    String? filter,
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (latitude != null) queryParameters['latitude'] = latitude;
      if (longitude != null) queryParameters['longitude'] = longitude;
      if (filter != null) queryParameters['filter'] = filter;
      if (search != null) queryParameters['search'] = search;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await dio.get(
        AppConstants.marketplaceDataEndpoint,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      if (response.statusCode == 200) {
        final apiResponse = MarketplaceApiResponse.fromJson(response.data);
        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!;
        } else {
          throw ServerException(
            apiResponse.message ?? 'Failed to get marketplace data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Failed to get marketplace data',
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
  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      final response = await dio.post(
        '/sales/cart/items',
        data: {
          'product_id': productId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['status'] == 'success' || data['success'] == true) {
          return data['data'] as Map<String, dynamic>;
        } else {
          throw ServerException(
            data['message'] ?? 'Failed to add item to cart',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Failed to add item to cart',
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
        final message = e.response?.data?['message'] ??
            e.response?.data?['error'] ??
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
