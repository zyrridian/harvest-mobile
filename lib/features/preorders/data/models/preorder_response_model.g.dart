// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preorder_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreOrderApiResponse _$PreOrderApiResponseFromJson(Map<String, dynamic> json) =>
    PreOrderApiResponse(
      status: json['status'] as String,
      data: json['data'] == null
          ? null
          : PreOrderModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PreOrderApiResponseToJson(
        PreOrderApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };
