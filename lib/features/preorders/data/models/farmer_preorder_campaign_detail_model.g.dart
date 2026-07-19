// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_preorder_campaign_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerPreorderCampaignDetailModel _$FarmerPreorderCampaignDetailModelFromJson(
        Map<String, dynamic> json) =>
    FarmerPreorderCampaignDetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      unit: json['unit'] as String,
      pricePerUnit:
          FarmerPreorderCampaignDetailModel._toDouble(json['pricePerUnit']),
      minimumOrderQuantity: (json['minimumOrderQuantity'] as num).toInt(),
      targetQuantity: (json['targetQuantity'] as num).toInt(),
      currentBookedQuantity: (json['currentBookedQuantity'] as num).toInt(),
      depositPercentage: FarmerPreorderCampaignDetailModel._toDouble(
          json['depositPercentage']),
      estimatedHarvestDate:
          DateTime.parse(json['estimatedHarvestDate'] as String),
      status: json['status'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      isScheduled: json['isScheduled'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      totalPeopleReserved: (json['totalPeopleReserved'] as num).toInt(),
      reservations: (json['reservations'] as List<dynamic>)
          .map((e) => FarmerPreorderReservationModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FarmerPreorderCampaignDetailModelToJson(
        FarmerPreorderCampaignDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
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
      'totalPeopleReserved': instance.totalPeopleReserved,
      'reservations': instance.reservations,
    };

FarmerPreorderReservationModel _$FarmerPreorderReservationModelFromJson(
        Map<String, dynamic> json) =>
    FarmerPreorderReservationModel(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      totalPrice: FarmerPreorderReservationModel._toDouble(json['totalPrice']),
      depositAmount:
          FarmerPreorderReservationModel._toDouble(json['depositAmount']),
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      deliveryMethod: json['deliveryMethod'] as String?,
      addressId: json['addressId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      fullAddress: json['fullAddress'] as String?,
      latitude:
          FarmerPreorderReservationModel._nullableToDouble(json['latitude']),
      longitude:
          FarmerPreorderReservationModel._nullableToDouble(json['longitude']),
      buyerId: json['buyerId'] as String,
      buyerName: json['buyerName'] as String,
      buyerAvatarUrl: json['buyerAvatarUrl'] as String?,
      conversationId: json['conversationId'] as String?,
    );

Map<String, dynamic> _$FarmerPreorderReservationModelToJson(
        FarmerPreorderReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
      'depositAmount': instance.depositAmount,
      'status': instance.status,
      'paymentMethod': instance.paymentMethod,
      'deliveryMethod': instance.deliveryMethod,
      'addressId': instance.addressId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'fullAddress': instance.fullAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'buyerId': instance.buyerId,
      'buyerName': instance.buyerName,
      'buyerAvatarUrl': instance.buyerAvatarUrl,
      'conversationId': instance.conversationId,
    };
