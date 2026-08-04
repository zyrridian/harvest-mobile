// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutePlanModel _$RoutePlanModelFromJson(Map<String, dynamic> json) =>
    RoutePlanModel(
      routeId: json['route_id'] as String,
      deliveryDate: json['delivery_date'] as String,
      status: json['status'] as String,
      trackingEnabled: json['tracking_enabled'] as bool,
      stopCount: (json['stop_count'] as num?)?.toInt() ?? 0,
      totalDistanceKm: (json['total_distance_km'] as num?)?.toDouble() ?? 0.0,
      estimatedMinutes: (json['estimated_minutes'] as num?)?.toInt() ?? 0,
      startedAt: json['started_at'] as String?,
      completedAt: json['completed_at'] as String?,
      stops: (json['stops'] as List<dynamic>?)
              ?.map((e) => RouteStopModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RoutePlanModelToJson(RoutePlanModel instance) =>
    <String, dynamic>{
      'route_id': instance.routeId,
      'delivery_date': instance.deliveryDate,
      'status': instance.status,
      'tracking_enabled': instance.trackingEnabled,
      'stop_count': instance.stopCount,
      'total_distance_km': instance.totalDistanceKm,
      'estimated_minutes': instance.estimatedMinutes,
      'started_at': instance.startedAt,
      'completed_at': instance.completedAt,
      'stops': instance.stops.map((e) => e.toJson()).toList(),
    };

RouteStopModel _$RouteStopModelFromJson(Map<String, dynamic> json) =>
    RouteStopModel(
      stopId: json['stop_id'] as String,
      stopOrder: (json['stop_order'] as num).toInt(),
      orderId: json['order_id'] as String?,
      orderNumber: json['order_number'] as String?,
      recipientName: json['recipient_name'] as String,
      addressLabel: json['address_label'] as String,
      status: json['status'] as String,
      estimatedArrival: json['estimated_arrival'] as String?,
      paymentMethod: json['payment_method'] as String?,
      totalAmount: json['total_amount'] as num?,
      buyerName: json['buyer_name'] as String?,
      addressLat: (json['address_lat'] as num?)?.toDouble(),
      addressLng: (json['address_lng'] as num?)?.toDouble(),
      requiresManualNavigation: json['requires_manual_navigation'] as bool?,
      actualArrival: json['actual_arrival'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => RouteStopItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RouteStopModelToJson(RouteStopModel instance) =>
    <String, dynamic>{
      'stop_id': instance.stopId,
      'stop_order': instance.stopOrder,
      'order_id': instance.orderId,
      'order_number': instance.orderNumber,
      'recipient_name': instance.recipientName,
      'address_label': instance.addressLabel,
      'status': instance.status,
      'estimated_arrival': instance.estimatedArrival,
      'payment_method': instance.paymentMethod,
      'total_amount': instance.totalAmount,
      'buyer_name': instance.buyerName,
      'address_lat': instance.addressLat,
      'address_lng': instance.addressLng,
      'requires_manual_navigation': instance.requiresManualNavigation,
      'actual_arrival': instance.actualArrival,
      'items': instance.items?.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
    };

RouteStopItemModel _$RouteStopItemModelFromJson(Map<String, dynamic> json) =>
    RouteStopItemModel(
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$RouteStopItemModelToJson(RouteStopItemModel instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'quantity': instance.quantity,
    };
