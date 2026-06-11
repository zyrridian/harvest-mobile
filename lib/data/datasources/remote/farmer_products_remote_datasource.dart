import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/product_model.dart';
import '../../models/review_model.dart';
import '../../models/paginated_response_model.dart';

abstract class FarmerProductsDataSource {
  Future<PaginatedResponseModel<ProductModel>> getFarmerProducts(String farmerId, {int? limit, int? page});
  Future<PaginatedResponseModel<ReviewModel>> getFarmerReviews(String farmerId, {int? limit, int? page});
}

class FarmerProductsRemoteDataSourceImpl implements FarmerProductsDataSource {
  final Dio dio;

  FarmerProductsRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaginatedResponseModel<ProductModel>> getFarmerProducts(String farmerId, {int? limit, int? page}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;

      final endpoint = AppConstants.farmerProductsEndpoint.replaceAll(':id', farmerId);
      final response = await dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return PaginatedResponseModel.fromJson(
          response.data,
          (json) => ProductModel.fromJson(json),
        );
      } else {
        throw ServerException(
          'Failed to fetch farmer products',
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
  Future<PaginatedResponseModel<ReviewModel>> getFarmerReviews(String farmerId, {int? limit, int? page}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;

      final endpoint = AppConstants.farmerReviewsEndpoint.replaceAll(':id', farmerId);
      final response = await dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return PaginatedResponseModel.fromJson(
          response.data,
          (json) => ReviewModel.fromJson(json),
        );
      } else {
        throw ServerException(
          'Failed to fetch farmer reviews',
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
