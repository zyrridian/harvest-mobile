// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_preorder_campaign_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerPreorderCampaignModel _$FarmerPreorderCampaignModelFromJson(
        Map<String, dynamic> json) =>
    FarmerPreorderCampaignModel(
      id: json['id'] as String,
      farmerId: json['farmerId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      unit: json['unit'] as String,
      pricePerUnit: FarmerPreorderCampaignModel._toDouble(json['pricePerUnit']),
      minimumOrderQuantity: (json['minimumOrderQuantity'] as num).toInt(),
      targetQuantity: (json['targetQuantity'] as num).toInt(),
      currentBookedQuantity: (json['currentBookedQuantity'] as num).toInt(),
      depositPercentage:
          FarmerPreorderCampaignModel._toDouble(json['depositPercentage']),
      estimatedHarvestDate:
          DateTime.parse(json['estimatedHarvestDate'] as String),
      status: json['status'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      isScheduled: json['isScheduled'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$FarmerPreorderCampaignModelToJson(
        FarmerPreorderCampaignModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmerId': instance.farmerId,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'unit': instance.unit,
      'pricePerUnit': instance.pricePerUnit,
      'minimumOrderQuantity': instance.minimumOrderQuantity,
      'targetQuantity': instance.targetQuantity,
      'currentBookedQuantity': instance.currentBookedQuantity,
      'depositPercentage': instance.depositPercentage,
      'estimatedHarvestDate': instance.estimatedHarvestDate.toIso8601String(),
      'status': instance.status,
      'images': instance.images,
      'isScheduled': instance.isScheduled,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
