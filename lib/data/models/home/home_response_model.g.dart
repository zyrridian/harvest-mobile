// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeApiResponse _$HomeApiResponseFromJson(Map<String, dynamic> json) =>
    HomeApiResponse(
      status: json['status'] as String,
      data: json['data'] == null
          ? null
          : HomeModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$HomeApiResponseToJson(HomeApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };
