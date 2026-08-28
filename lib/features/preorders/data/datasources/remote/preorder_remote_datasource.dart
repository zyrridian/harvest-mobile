import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/preorders/data/models/farmer_preorder_campaign_detail_model.dart';
import 'package:harvest_app/features/preorders/data/models/farmer_preorder_campaign_model.dart';
import 'package:harvest_app/features/preorders/data/models/preorder_model.dart';
import 'package:harvest_app/features/preorders/data/models/campaign_model.dart';
import 'package:harvest_app/features/preorders/domain/entities/create_preorder_campaign_params.dart';

abstract class PreOrderRemoteDataSource {
  // New endpoints
  Future<PreorderCampaignModel> getCampaignDetail(String id);
  Future<PreorderCampaignModel> createCampaign(
      CreatePreorderCampaignParams params);
  Future<PreorderCampaignModel> updateCampaign(
      String id, CreatePreorderCampaignParams params);
  Future<PreorderCampaignModel> updateCampaignStatus(String id, String status);
  Future<void> deleteCampaign(String id);
  Future<List<PreorderCampaignModel>> getActiveCampaigns(
      {String? filter, double? latitude, double? longitude});
  Future<List<FarmerPreorderCampaignModel>> getMyCampaigns();
  Future<FarmerPreorderCampaignDetailModel> getFarmerCampaignDetail(String id);
  Future<List<PreOrderReservationModel>> getMyReservations();
  Future<Map<String, dynamic>> reserveSpot(
      String id, int quantity, String deliveryMethod, String? addressId);
  Future<Map<String, dynamic>> arrangePickup(String id, DateTime pickupTime);
  Future<Map<String, dynamic>> cancelReservation(String id);
  Future<Map<String, dynamic>> completeReservation(String id);
  Future<Map<String, dynamic>> updateReservationStatus(String id, String status);
  Future<Map<String, dynamic>> fulfillCampaign(String id);
}

class PreOrderRemoteDataSourceImpl implements PreOrderRemoteDataSource {
  final Dio dio;

  PreOrderRemoteDataSourceImpl(this.dio);

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
  Future<PreorderCampaignModel> getCampaignDetail(String id) async {
    try {
      final response = await dio.get('/preorders/campaigns/$id');
      if (response.data['status'] == 'success') {
        return PreorderCampaignModel.fromJson(response.data['data']);
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to load campaign');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<PreorderCampaignModel> createCampaign(
      CreatePreorderCampaignParams params) async {
    try {
      final response = await dio.post(
        '/preorders/campaigns',
        data: params.toJson(),
      );
      if (response.data['status'] == 'success') {
        return PreorderCampaignModel.fromJson(response.data['data']);
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to create campaign');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<PreorderCampaignModel> updateCampaign(
      String id, CreatePreorderCampaignParams params) async {
    try {
      final response = await dio.put(
        '/preorders/campaigns/$id',
        data: params.toJson(),
      );
      if (response.data['status'] == 'success') {
        return PreorderCampaignModel.fromJson(response.data['data']);
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to update campaign');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<PreorderCampaignModel> updateCampaignStatus(
      String id, String status) async {
    try {
      final response = await dio.put(
        '/preorders/campaigns/$id',
        data: {'status': status},
      );
      if (response.data['status'] == 'success' ||
          response.data['success'] == true) {
        return PreorderCampaignModel.fromJson(response.data['data']);
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to update campaign status');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deleteCampaign(String id) async {
    try {
      final response = await dio.delete('/preorders/campaigns/$id');
      if (response.data['status'] == 'success' ||
          response.data['success'] == true) {
        return;
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to delete campaign');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<PreorderCampaignModel>> getActiveCampaigns(
      {String? filter, double? latitude, double? longitude}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (filter != null && filter.toLowerCase() != 'all') {
        queryParams['filter'] = filter;
      }
      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;

      final response =
          await dio.get('/preorders/campaigns', queryParameters: queryParams);
      if (response.data['status'] == 'success') {
        return (response.data['data'] as List)
            .map((e) => PreorderCampaignModel.fromJson(e))
            .toList();
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to load campaigns');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<FarmerPreorderCampaignModel>> getMyCampaigns() async {
    try {
      final response = await dio.get('/preorders/campaigns/me');
      if (response.data['status'] == 'success') {
        return (response.data['data'] as List)
            .map((e) => FarmerPreorderCampaignModel.fromJson(e))
            .toList();
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to load campaigns');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<FarmerPreorderCampaignDetailModel> getFarmerCampaignDetail(
      String id) async {
    try {
      final response = await dio.get('/preorders/campaigns/me/$id');
      if (response.data['status'] == 'success') {
        return FarmerPreorderCampaignDetailModel.fromJson(
            response.data['data']);
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to load campaign detail');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<PreOrderReservationModel>> getMyReservations() async {
    try {
      final response = await dio.get('/preorders/reservations');
      if (response.data['status'] == 'success') {
        return (response.data['data'] as List)
            .map((e) => PreOrderReservationModel.fromJson(e))
            .toList();
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to load reservations');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> reserveSpot(
      String id, int quantity, String deliveryMethod, String? addressId) async {
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
        return response.data['data'] ?? {};
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to reserve spot');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> arrangePickup(
      String id, DateTime pickupTime) async {
    try {
      final response = await dio.post(
        '/preorders/reservations/$id/pickup',
        data: {'pickup_time': pickupTime.toIso8601String()},
      );
      if (response.data['status'] == 'success') {
        return response.data['data'] ?? {};
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to arrange pickup');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> cancelReservation(String id) async {
    try {
      final response = await dio.post('/preorders/reservations/$id/cancel');
      if (response.data['status'] == 'success') {
        return response.data['data'] ?? {};
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to cancel reservation');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> completeReservation(String id) async {
    try {
      final response = await dio.patch('/preorders/reservations/$id/complete');
      if (response.data['status'] == 'success') {
        return response.data['data'] ?? {};
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to complete reservation');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateReservationStatus(String id, String status) async {
    try {
      final response = await dio.patch(
        '/preorders/reservations/$id/status',
        data: {'status': status},
      );
      if (response.data['status'] == 'success') {
        return response.data['data'] ?? {};
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to update reservation status');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> fulfillCampaign(String id) async {
    try {
      final response = await dio.post('/preorders/campaigns/$id/fulfill');
      if (response.data['status'] == 'success') {
        return response.data ?? {};
      }
      throw ServerException(
          response.data['message'] ?? 'Failed to fulfill campaign');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}
