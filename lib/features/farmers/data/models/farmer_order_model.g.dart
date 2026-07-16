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
      buyer:
          FarmerOrderBuyerModel.fromJson(json['buyer'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => FarmerOrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: json['total_amount'] as num,
      deliveryMethod: json['delivery_method'] as String?,
      deliveryDate: json['delivery_date'] as String?,
    );

Map<String, dynamic> _$FarmerOrderModelToJson(FarmerOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'buyer': instance.buyer.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total_amount': instance.totalAmount,
      'delivery_method': instance.deliveryMethod,
      'delivery_date': instance.deliveryDate,
    };

FarmerOrderBuyerModel _$FarmerOrderBuyerModelFromJson(
        Map<String, dynamic> json) =>
    FarmerOrderBuyerModel(
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$FarmerOrderBuyerModelToJson(
        FarmerOrderBuyerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
    };

FarmerOrderItemModel _$FarmerOrderItemModelFromJson(
        Map<String, dynamic> json) =>
    FarmerOrderItemModel(
      productName: json['product_name'] as String,
      productImage: json['product_image'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      subtotal: json['subtotal'] as num,
    );

Map<String, dynamic> _$FarmerOrderItemModelToJson(
        FarmerOrderItemModel instance) =>
    <String, dynamic>{
      'product_name': instance.productName,
      'product_image': instance.productImage,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
    };
