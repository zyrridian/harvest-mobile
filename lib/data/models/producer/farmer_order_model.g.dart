// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerOrderModel _$FarmerOrderModelFromJson(Map<String, dynamic> json) =>
    FarmerOrderModel(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      buyerName: json['buyer_name'] as String?,
      buyerAvatar: json['buyer_avatar'] as String?,
      firstItem: json['first_item'] == null
          ? null
          : FarmerOrderFirstItemModel.fromJson(
              json['first_item'] as Map<String, dynamic>),
      itemsCount: (json['items_count'] as num?)?.toInt(),
      totalAmount: json['total_amount'] as num,
      deliveryMethod: json['delivery_method'] as String?,
    );

Map<String, dynamic> _$FarmerOrderModelToJson(FarmerOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'buyer_name': instance.buyerName,
      'buyer_avatar': instance.buyerAvatar,
      'first_item': instance.firstItem?.toJson(),
      'items_count': instance.itemsCount,
      'total_amount': instance.totalAmount,
      'delivery_method': instance.deliveryMethod,
    };

FarmerOrderFirstItemModel _$FarmerOrderFirstItemModelFromJson(
        Map<String, dynamic> json) =>
    FarmerOrderFirstItemModel(
      name: json['name'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$FarmerOrderFirstItemModelToJson(
        FarmerOrderFirstItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
    };
