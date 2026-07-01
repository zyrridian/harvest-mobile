// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      orderItemId: json['order_item_id'] as String,
      product: json['product'] as Map<String, dynamic>,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toInt(),
      discount: (json['discount'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toInt(),
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'order_item_id': instance.orderItemId,
      'product': instance.product,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'discount': instance.discount,
      'subtotal': instance.subtotal,
    };

OrderSellerModel _$OrderSellerModelFromJson(Map<String, dynamic> json) =>
    OrderSellerModel(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      profilePicture: json['profile_picture'] as String?,
    );

Map<String, dynamic> _$OrderSellerModelToJson(OrderSellerModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'profile_picture': instance.profilePicture,
    };

OrderDeliveryModel _$OrderDeliveryModelFromJson(Map<String, dynamic> json) =>
    OrderDeliveryModel(
      method: json['method'] as String,
      address: json['address'] as Map<String, dynamic>?,
      date: json['date'] as String?,
      timeSlot: json['time_slot'] as String?,
      fee: (json['fee'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OrderDeliveryModelToJson(OrderDeliveryModel instance) =>
    <String, dynamic>{
      'method': instance.method,
      'address': instance.address,
      'date': instance.date,
      'time_slot': instance.timeSlot,
      'fee': instance.fee,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      orderId: json['order_id'] as String,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      seller: OrderSellerModel.fromJson(json['seller'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      delivery:
          OrderDeliveryModel.fromJson(json['delivery'] as Map<String, dynamic>),
      totalAmount: (json['total_amount'] as num).toInt(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'seller': instance.seller.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'delivery': instance.delivery.toJson(),
      'total_amount': instance.totalAmount,
    };
