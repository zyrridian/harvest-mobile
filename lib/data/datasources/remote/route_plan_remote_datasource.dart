import 'package:dio/dio.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/producer/route_plan_model.dart';

abstract class RoutePlanRemoteDataSource {
  Future<List<RoutePlanModel>> getRoutePlans(String date);
  Future<RoutePlanModel> getRoutePlanDetail(String routeId);
  Future<RoutePlanModel> createRoutePlan(
      String date, List<String> orderIds, bool trackingEnabled);
}

class RoutePlanRemoteDataSourceImpl implements RoutePlanRemoteDataSource {
  final Dio dio;

  RoutePlanRemoteDataSourceImpl(this.dio);

  @override
  Future<List<RoutePlanModel>> getRoutePlans(String date) async {
    try {
      final response = await dio.get(
        AppConstants.producerRoutesEndpoint,
        queryParameters: {'date': date},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          final routesList = data['data']['routes'] as List;
          return routesList.map((json) => RoutePlanModel.fromJson(json)).toList();
        } else {
          throw ServerException(data['message'] ?? 'Failed to get route plans',
              statusCode: response.statusCode);
        }
      } else {
        throw ServerException('Failed to get route plans',
            statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<RoutePlanModel> getRoutePlanDetail(String routeId) async {
    try {
      final response = await dio.get('${AppConstants.producerRoutesEndpoint}/$routeId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          return RoutePlanModel.fromJson(data['data']);
        } else {
          throw ServerException(
              data['message'] ?? 'Failed to get route plan detail',
              statusCode: response.statusCode);
        }
      } else {
        throw ServerException('Failed to get route plan detail',
            statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<RoutePlanModel> createRoutePlan(
      String date, List<String> orderIds, bool trackingEnabled) async {
    try {
      final response = await dio.post(
        AppConstants.producerRoutesEndpoint,
        data: {
          'delivery_date': date,
          'order_ids': orderIds,
          'tracking_enabled': trackingEnabled,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          return RoutePlanModel.fromJson(data['data']);
        } else {
          throw ServerException(data['message'] ?? 'Failed to create route plan',
              statusCode: response.statusCode);
        }
      } else {
        throw ServerException('Failed to create route plan',
            statusCode: response.statusCode);
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
