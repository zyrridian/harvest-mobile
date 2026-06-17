// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_schedule_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarvestScheduleApiResponse _$HarvestScheduleApiResponseFromJson(
        Map<String, dynamic> json) =>
    HarvestScheduleApiResponse(
      status: json['status'] as String,
      data: json['data'] == null
          ? null
          : HarvestScheduleDashboardModel.fromJson(
              json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$HarvestScheduleApiResponseToJson(
        HarvestScheduleApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };
