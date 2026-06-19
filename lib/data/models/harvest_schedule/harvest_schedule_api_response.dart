import 'package:harvest_app/data/models/harvest_schedule/harvest_schedule_dashboard_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harvest_schedule_api_response.g.dart';

@JsonSerializable()
class HarvestScheduleApiResponse {
  final String status;
  final HarvestScheduleDashboardModel? data;
  final String? message;

  HarvestScheduleApiResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory HarvestScheduleApiResponse.fromJson(Map<String, dynamic> json) =>
      _$HarvestScheduleApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HarvestScheduleApiResponseToJson(this);

  bool get isSuccess => status == 'success';
}
