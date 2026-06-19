import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/preorder/preorder_model.dart';
import 'package:harvest_app/data/models/preorder/preorder_response_model.dart';

abstract class PreOrderRemoteDataSource {
  Future<PreOrderModel> getPreOrderData({String? status});
  Future<Map<String, dynamic>> reservePreOrder({required String harvestId, required int quantity});
}

class PreOrderRemoteDataSourceImpl implements PreOrderRemoteDataSource {
  final Dio dio;

  PreOrderRemoteDataSourceImpl(this.dio);

  @override
  Future<PreOrderModel> getPreOrderData({String? status}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // For now, return dummy JSON data that simulates the real response
    final dummyJson = {
      "status": "success",
      "message": "Pre-order data fetched successfully",
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
          },
          {
            "id": "h2",
            "title": "Ikan Salmon Trout Whole F...",
            "farmer_name": "Fish Factory",
            "distance": "2.6 km",
            "image_url": "🐠",
            "price": 1140000,
            "unit": "kg",
            "booked_quantity": 0,
            "total_quantity": 40,
            "days_left": 156,
            "status": "Open"
          }
        ],
        "active_reservations": [
          {
            "id": "r1",
            "title": "Tomat Cherry Merah",
            "quantity_str": "5 kg",
            "farmer_name": "Green Valley Farm",
            "days_to_harvest": 12,
            "image_url": "🍅",
            "status": "Confirmed"
          },
          {
            "id": "r2",
            "title": "Beras Pandan Wangi",
            "quantity_str": "10 kg",
            "farmer_name": "Fresh Fields Co.",
            "days_to_harvest": 45,
            "image_url": "🌾",
            "status": "Pending"
          }
        ]
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
  Future<Map<String, dynamic>> reservePreOrder({required String harvestId, required int quantity}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulated dummy JSON response
    final dummyJson = {
      "status": "success",
      "message": "Reservation successful",
      "data": {
        "reservation_id": "r_new_${DateTime.now().millisecondsSinceEpoch}",
        "status": "Pending"
      }
    };

    try {
      if (dummyJson['status'] == 'success') {
        return dummyJson['data'] as Map<String, dynamic>;
      } else {
        throw ServerException('Failed to reserve harvest');
      }
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}
