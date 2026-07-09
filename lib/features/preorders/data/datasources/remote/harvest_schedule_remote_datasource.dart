import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/harvest_schedule/harvest_schedule_api_response.dart';
import 'package:harvest_app/data/models/harvest_schedule/harvest_schedule_dashboard_model.dart';

abstract class HarvestScheduleRemoteDataSource {
  Future<HarvestScheduleDashboardModel> getHarvestSchedule({String? month});
  Future<Map<String, dynamic>> payDeposit({required String harvestId});
  Future<Map<String, dynamic>> arrangePickup({
    required String harvestId,
    required String pickupTime,
  });
  Future<HarvestScheduleDashboardModel> getScheduleDashboard({String? month, double? latitude, double? longitude});
}

class HarvestScheduleRemoteDataSourceImpl
    implements HarvestScheduleRemoteDataSource {
  final Dio dio;

  HarvestScheduleRemoteDataSourceImpl(this.dio);

  @override
  Future<HarvestScheduleDashboardModel> getHarvestSchedule({
    String? month,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final dummyJson = {
      "status": "success",
      "data": {
        "this_week_count": 3,
        "ready_today_count": 1,
        "this_month_count": 12,
        "items": [
          {
            "id": "1",
            "title": "Tomat Cherry Merah",
            "farmer_name": "Green Valley Farm",
            "distance": 1.7,
            "image_url": "🍅",
            "status_text": "Now",
            "price": 56000,
            "badges": ["Ready to pick", "Pre-ordered"],
            "description_text": "5 kg reserved · paid Rp 14.000 deposit",
            "action_button_1": "Chat\nfarmer",
            "action_button_2": "Arrange\npickup",
            "date_group": "TODAY — JUN 13",
            "is_today": true,
            "date_day_filter": "13"
          },
          {
            "id": "2",
            "title": "Beras Pandan Wangi",
            "farmer_name": "Fresh Fields Co.",
            "distance": 2.6,
            "image_url": "🌾",
            "status_text": "3",
            "price": 120000,
            "badges": ["Pending confirmation"],
            "description_text": "10 kg reserved · deposit pending",
            "action_button_1": "View\ndetails",
            "action_button_2": "Pay\ndeposit",
            "date_group": "MON, JUN 16",
            "is_today": false,
            "date_day_filter": "16"
          },
          {
            "id": "3",
            "title": "Strawberry Ganitri Batch #4",
            "farmer_name": "Sunrise Organic",
            "distance": 0.7,
            "image_url": "🍓",
            "status_text": "3",
            "price": 84000,
            "badges": ["Confirmed", "Pre-ordered"],
            "description_text": "3 kg reserved",
            "action_button_1": "",
            "action_button_2": "",
            "date_group": "MON, JUN 16",
            "is_today": false,
            "date_day_filter": "16"
          },
          {
            "id": "4",
            "title": "Ikan Salmon Trout Whole F.",
            "farmer_name": "Fish Factory",
            "distance": 2.6,
            "image_url": "🐠",
            "status_text": "15",
            "price": 2280000,
            "badges": ["Just reserved"],
            "description_text": "2 kg reserved",
            "action_button_1": "",
            "action_button_2": "",
            "date_group": "SAT, JUN 28",
            "is_today": false,
            "date_day_filter": "28"
          }
        ]
      }
    };

    try {
      final response = HarvestScheduleApiResponse.fromJson(dummyJson);
      if (response.isSuccess && response.data != null) {
        return response.data!;
      } else {
        throw ServerException('Failed to fetch harvest schedule data');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> payDeposit({required String harvestId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final dummyJson = {
      "status": "success",
      "message": "Deposit paid successfully",
      "data": {"harvest_id": harvestId, "status": "Confirmed"}
    };
    if (dummyJson['status'] == 'success') {
      return dummyJson['data'] as Map<String, dynamic>;
    } else {
      throw ServerException('Failed to pay deposit');
    }
  }

  @override
  Future<Map<String, dynamic>> arrangePickup({
    required String harvestId,
    required String pickupTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final dummyJson = {
      "status": "success",
      "message": "Pickup arranged successfully",
      "data": {
        "harvest_id": harvestId,
        "pickup_time": pickupTime,
        "status": "Pickup Arranged"
      }
    };
    if (dummyJson['status'] == 'success') {
      return dummyJson['data'] as Map<String, dynamic>;
    } else {
      throw ServerException('Failed to arrange pickup');
    }
  }

  @override
  Future<HarvestScheduleDashboardModel> getScheduleDashboard({String? month, double? latitude, double? longitude}) async {
    try {
      final Map<String, dynamic> params = {};
      if (month != null) params['month'] = month;
      if (latitude != null) params['latitude'] = latitude;
      if (longitude != null) params['longitude'] = longitude;

      final response = await dio.get('/preorders/schedule', queryParameters: params);
      if (response.data['status'] == 'success') {
        return HarvestScheduleDashboardModel.fromJson(response.data['data']);
      }
      throw ServerException('Failed to fetch schedule dashboard');
    } catch (e) {
      throw ServerException('Failed to fetch schedule dashboard: $e');
    }
  }
}
