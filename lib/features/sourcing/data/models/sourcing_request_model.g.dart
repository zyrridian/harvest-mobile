// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sourcing_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SourcingBuyerModelImpl _$$SourcingBuyerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SourcingBuyerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$$SourcingBuyerModelImplToJson(
        _$SourcingBuyerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
    };

_$SourcingRequestModelImpl _$$SourcingRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SourcingRequestModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      budget: (json['budget'] as num?)?.toDouble(),
      requiredBy: json['required_by'] == null
          ? null
          : DateTime.parse(json['required_by'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      offersCount: (json['offers_count'] as num?)?.toInt() ?? 0,
      buyer: json['buyer'] == null
          ? null
          : SourcingBuyerModel.fromJson(json['buyer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SourcingRequestModelImplToJson(
        _$SourcingRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'budget': instance.budget,
      'required_by': instance.requiredBy?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'offers_count': instance.offersCount,
      'buyer': instance.buyer,
    };
