// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplaceApiResponse _$MarketplaceApiResponseFromJson(
        Map<String, dynamic> json) =>
    MarketplaceApiResponse(
      status: json['status'] as String,
      data: json['data'] == null
          ? null
          : MarketplaceModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MarketplaceApiResponseToJson(
        MarketplaceApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };
