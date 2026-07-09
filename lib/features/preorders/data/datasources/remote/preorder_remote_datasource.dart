import 'package:dio/dio.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/preorder/preorder_model.dart';
import 'package:harvest_app/data/models/preorder/preorder_response_model.dart';
import 'package:harvest_app/data/models/preorder/campaign_model.dart';
import 'package:harvest_app/domain/entities/create_preorder_campaign_params.dart';

abstract class PreOrderRemoteDataSource {
  Future<PreOrderModel> getPreOrderData({double? latitude, double? longitude});
  
  // New endpoints
  Future<PreorderCampaignModel> createCampaign(CreatePreorderCampaignParams params);
  Future<List<PreorderCampaignModel>> getActiveCampaigns();
  Future<List<PreorderCampaignModel>> getMyCampaigns();
  Future<Map<String, dynamic>> reserveSpot(String id, int quantity, String deliveryMethod, String? addressId);
  Future<Map<String, dynamic>> payDeposit(String id, String paymentMethod);
  Future<Map<String, dynamic>> arrangePickup(String id, DateTime pickupTime);
  Future<Map<String, dynamic>> cancelReservation(String id);
}

class PreOrderRemoteDataSourceImpl implements PreOrderRemoteDataSource {
  final Dio dio;

  PreOrderRemoteDataSourceImpl(this.dio);

  @override
  Future<PreOrderModel> getPreOrderData({double? latitude, double? longitude}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (latitude != null) queryParameters['latitude'] = latitude;
      if (longitude != null) queryParameters['longitude'] = longitude;

      final response = await dio.get(
        AppConstants.getPreorderDashboardEndpoint,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      if (response.statusCode == 200) {
        final apiResponse = PreOrderApiResponse.fromJson(response.data);
        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!;
        } else {
          throw ServerException(
            apiResponse.message ?? 'Failed to get preorder data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          'Failed to get preorder data',
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

  @override
  Future<PreorderCampaignModel> createCampaign(CreatePreorderCampaignParams params) async {
    try {
      final response = await dio.post(
        '/preorders/campaigns',
        data: params.toJson(),
      );
      if (response.data['status'] == 'success') {
        return PreorderCampaignModel.fromJson(response.data['data']);
      }
      throw ServerException('Failed to create campaign');
    } catch (e) {
      throw ServerException('Failed to create campaign: $e');
    }
  }

  @override
  Future<List<PreorderCampaignModel>> getActiveCampaigns() async {
    try {
      final response = await dio.get('/preorders/campaigns');
      if (response.data['status'] == 'success') {
        return (response.data['data'] as List)
            .map((e) => PreorderCampaignModel.fromJson(e))
            .toList();
      }
      throw ServerException('Failed to load campaigns');
    } catch (e) {
      throw ServerException('Failed to load campaigns: $e');
    }
  }

  @override
  Future<List<PreorderCampaignModel>> getMyCampaigns() async {
    try {
      final response = await dio.get('/preorders/campaigns/me');
      if (response.data['status'] == 'success') {
        return (response.data['data'] as List)
            .map((e) => PreorderCampaignModel.fromJson(e))
            .toList();
      }
      throw ServerException('Failed to load campaigns');
    } catch (e) {
      throw ServerException('Failed to load campaigns: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> reserveSpot(String id, int quantity, String deliveryMethod, String? addressId) async {
    try {
      final response = await dio.post(
        '/preorders/campaigns/$id/reserve',
        data: {
          'quantity': quantity,
          'delivery_method': deliveryMethod,
          if (addressId != null) 'address_id': addressId,
        },
      );
      if (response.data['status'] == 'success') {
        return response.data['data'];
      }
      throw ServerException('Failed to reserve spot');
    } catch (e) {
      throw ServerException('Failed to reserve spot: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> payDeposit(String id, String paymentMethod) async {
    try {
      final response = await dio.post(
        '/preorders/reservations/$id/pay',
        data: {'paymentMethod': paymentMethod},
      );
      if (response.data['status'] == 'success') {
        return response.data['data'];
      }
      throw ServerException('Failed to pay deposit');
    } catch (e) {
      throw ServerException('Failed to pay deposit: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> arrangePickup(String id, DateTime pickupTime) async {
    try {
      final response = await dio.post(
        '/preorders/reservations/$id/pickup',
        data: {'pickup_time': pickupTime.toIso8601String()},
      );
      if (response.data['status'] == 'success') {
        return response.data['data'];
      }
      throw ServerException('Failed to arrange pickup');
    } catch (e) {
      throw ServerException('Failed to arrange pickup: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> cancelReservation(String id) async {
    try {
      final response = await dio.post('/preorders/reservations/$id/cancel');
      if (response.data['status'] == 'success') {
        return response.data['data'];
      }
      throw ServerException('Failed to cancel reservation');
    } catch (e) {
      throw ServerException('Failed to cancel reservation: $e');
    }
  }
}

