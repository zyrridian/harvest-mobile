// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      cartItemId: json['cart_item_id'] as String,
      product: json['product'] as Map<String, dynamic>,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toInt(),
      discountPrice: (json['discount_price'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toInt(),
      notes: json['notes'] as String?,
      isSelected: json['is_selected'] as bool,
      isAvailable: json['is_available'] as bool,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'cart_item_id': instance.cartItemId,
      'product': instance.product,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'discount_price': instance.discountPrice,
      'subtotal': instance.subtotal,
      'notes': instance.notes,
      'is_selected': instance.isSelected,
      'is_available': instance.isAvailable,
    };

CartSummaryModel _$CartSummaryModelFromJson(Map<String, dynamic> json) =>
    CartSummaryModel(
      totalItems: (json['total_items'] as num).toInt(),
      totalQuantity: (json['total_quantity'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toInt(),
      totalDiscount: (json['total_discount'] as num).toInt(),
      totalDeliveryFee: (json['total_delivery_fee'] as num).toInt(),
      serviceFee: (json['service_fee'] as num).toInt(),
      grandTotal: (json['grand_total'] as num).toInt(),
    );

Map<String, dynamic> _$CartSummaryModelToJson(CartSummaryModel instance) =>
    <String, dynamic>{
      'total_items': instance.totalItems,
      'total_quantity': instance.totalQuantity,
      'subtotal': instance.subtotal,
      'total_discount': instance.totalDiscount,
      'total_delivery_fee': instance.totalDeliveryFee,
      'service_fee': instance.serviceFee,
      'grand_total': instance.grandTotal,
    };

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
      cartId: json['cart_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      groupedBySeller: (json['grouped_by_seller'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      summary:
          CartSummaryModel.fromJson(json['summary'] as Map<String, dynamic>),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
      'cart_id': instance.cartId,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'grouped_by_seller': instance.groupedBySeller,
      'summary': instance.summary.toJson(),
      'recommendations': instance.recommendations,
    };
