import 'package:dio/dio.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/home/home_model.dart';
import 'package:harvest_app/data/models/home/home_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<HomeModel> getHomeData() async {
    try {
      final response = await dio.get(AppConstants.getHomeDataEndpoint);

      if (response.statusCode == 200) {
        final apiResponse = HomeApiResponse.fromJson(response.data);
        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!;
        } else {
          throw ServerException(
            apiResponse.message ?? 'Failed to get home data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Failed to get home data',
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
