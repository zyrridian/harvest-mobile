// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvincesApiResponse _$ProvincesApiResponseFromJson(
        Map<String, dynamic> json) =>
    ProvincesApiResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ProvincesApiResponseToJson(
        ProvincesApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };

CitiesApiResponse _$CitiesApiResponseFromJson(Map<String, dynamic> json) =>
    CitiesApiResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$CitiesApiResponseToJson(CitiesApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };

DistrictsApiResponse _$DistrictsApiResponseFromJson(
        Map<String, dynamic> json) =>
    DistrictsApiResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DistrictsApiResponseToJson(
        DistrictsApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };
