import 'package:dio/dio.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/system/data/models/master_model.dart';
import 'package:harvest_app/features/system/data/models/master_response_model.dart';

abstract class MasterRemoteDataSource {
  Future<List<ProvinceModel>> getProvinces();
  Future<List<CityModel>> getCities({required int provinceId});
  Future<List<DistrictModel>> getDistricts({required int cityId});
}

class MasterRemoteDataSourceImpl implements MasterRemoteDataSource {
  final Dio dio;

  MasterRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProvinceModel>> getProvinces() async {
    try {
      final response = await dio.get(AppConstants.provincesEndpoint);

      if (response.statusCode == 200) {
        final apiResponse = ProvincesApiResponse.fromJson(response.data);
        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!;
        } else {
          throw ServerException(
            apiResponse.message ?? 'Failed to get provinces data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Failed to get provinces data',
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
  Future<List<CityModel>> getCities({required int provinceId}) async {
    try {
      final response = await dio.get(
        AppConstants.citiesEndpoint,
        queryParameters: {'province_id': provinceId},
      );

      if (response.statusCode == 200) {
        final apiResponse = CitiesApiResponse.fromJson(response.data);
        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!;
        } else {
          throw ServerException(
            apiResponse.message ?? 'Failed to get cities data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Failed to get cities data',
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
  Future<List<DistrictModel>> getDistricts({required int cityId}) async {
    try {
      final response = await dio.get(
        AppConstants.districtsEndpoint,
        queryParameters: {'city_id': cityId},
      );

      if (response.statusCode == 200) {
        final apiResponse = DistrictsApiResponse.fromJson(response.data);
        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!;
        } else {
          throw ServerException(
            apiResponse.message ?? 'Failed to get districts data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Failed to get districts data',
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
