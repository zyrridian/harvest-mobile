import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/preorder/preorder_model.dart';
import 'package:harvest_app/data/models/preorder/preorder_response_model.dart';
import 'package:harvest_app/data/models/preorder/campaign_model.dart';

abstract class PreOrderRemoteDataSource {
  Future<PreOrderModel> getPreOrderData({String? status});
  
  // New endpoints
  Future<PreorderCampaignModel> createCampaign(PreorderCampaignModel campaign);
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
  Future<PreOrderModel> getPreOrderData({String? status}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final dummyJson = {
      "status": "success",
      "data": {
        "active_harvests_count": 12,
        "your_reservations_count": 3,
        "avg_savings": "30%",
        "available_harvests": [
          {
            "id": "h1",
            "title": "Strawberry Ganitri — Batch #4",
            "farmer_name": "Sunrise Organic",
            "distance": "0.7 km",
            "image_url": "🍓",
            "price": 28000,
            "unit": "kg",
            "booked_quantity": 87,
            "total_quantity": 100,
            "days_left": 8,
            "status": "Almost full"
          }
        ],
        "active_reservations": []
      }
    };

    try {
      final apiResponse = PreOrderApiResponse.fromJson(dummyJson);
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw ServerException('Failed to get preorder data');
      }
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<PreorderCampaignModel> createCampaign(PreorderCampaignModel campaign) async {
    try {
      final response = await dio.post(
        '/api/v1/preorders/campaigns',
        data: campaign.toJson(),
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
      final response = await dio.get('/api/v1/preorders/campaigns');
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
      final response = await dio.get('/api/v1/preorders/campaigns/me');
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
        '/api/v1/preorders/campaigns/$id/reserve',
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
        '/api/v1/preorders/reservations/$id/pay',
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
        '/api/v1/preorders/reservations/$id/pickup',
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
      final response = await dio.post('/api/v1/preorders/reservations/$id/cancel');
      if (response.data['status'] == 'success') {
        return response.data['data'];
      }
      throw ServerException('Failed to cancel reservation');
    } catch (e) {
      throw ServerException('Failed to cancel reservation: $e');
    }
  }
}

