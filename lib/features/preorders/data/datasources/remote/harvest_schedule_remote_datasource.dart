import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/preorders/data/models/harvest_schedule_dashboard_model.dart';

abstract class HarvestScheduleRemoteDataSource {
  Future<HarvestScheduleDashboardModel> getScheduleDashboard({String? month, double? latitude, double? longitude});
  Future<void> addToSchedule({required String campaignId, bool remindersEnabled = true});
  Future<void> removeFromSchedule({required String campaignId});
}

class HarvestScheduleRemoteDataSourceImpl
    implements HarvestScheduleRemoteDataSource {
  final Dio dio;

  HarvestScheduleRemoteDataSourceImpl(this.dio);

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

  @override
  Future<void> addToSchedule({required String campaignId, bool remindersEnabled = true}) async {
    try {
      final response = await dio.post(
        '/preorders/schedule/campaigns/$campaignId',
        data: {'reminders_enabled': remindersEnabled},
      );
      if (response.data['status'] != 'success') {
        throw ServerException('Failed to add to schedule');
      }
    } catch (e) {
      throw ServerException('Failed to add to schedule: $e');
    }
  }

  @override
  Future<void> removeFromSchedule({required String campaignId}) async {
    try {
      final response = await dio.delete('/preorders/schedule/campaigns/$campaignId');
      if (response.data['status'] != 'success') {
        throw ServerException('Failed to remove from schedule');
      }
    } catch (e) {
      throw ServerException('Failed to remove from schedule: $e');
    }
  }
}
