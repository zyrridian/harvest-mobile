import 'package:harvest_app/features/farmers/domain/entities/route_plan.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_plan_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RoutePlanModel {
  @JsonKey(name: 'route_id')
  final String routeId;
  @JsonKey(name: 'delivery_date')
  final String deliveryDate;
  final String status;
  @JsonKey(name: 'tracking_enabled')
  final bool trackingEnabled;
  @JsonKey(name: 'stop_count', defaultValue: 0)
  final int stopCount;
  @JsonKey(name: 'total_distance_km', defaultValue: 0.0)
  final double totalDistanceKm;
  @JsonKey(name: 'estimated_minutes', defaultValue: 0)
  final int estimatedMinutes;
  @JsonKey(name: 'started_at')
  final String? startedAt;
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @JsonKey(defaultValue: [])
  final List<RouteStopModel> stops;

  RoutePlanModel({
    required this.routeId,
    required this.deliveryDate,
    required this.status,
    required this.trackingEnabled,
    required this.stopCount,
    required this.totalDistanceKm,
    required this.estimatedMinutes,
    this.startedAt,
    this.completedAt,
    required this.stops,
  });

  factory RoutePlanModel.fromJson(Map<String, dynamic> json) =>
      _$RoutePlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoutePlanModelToJson(this);

  RoutePlan toEntity() {
    return RoutePlan(
      routeId: routeId,
      deliveryDate: deliveryDate,
      status: status,
      trackingEnabled: trackingEnabled,
      stopCount: stopCount,
      totalDistanceKm: totalDistanceKm,
      estimatedMinutes: estimatedMinutes,
      startedAt: startedAt,
      completedAt: completedAt,
      stops: stops.map((s) => s.toEntity()).toList(),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class RouteStopModel {
  @JsonKey(name: 'stop_id')
  final String stopId;
  @JsonKey(name: 'stop_order')
  final int stopOrder;
  @JsonKey(name: 'order_id')
  final String? orderId;
  @JsonKey(name: 'order_number')
  final String? orderNumber;
  @JsonKey(name: 'recipient_name')
  final String recipientName;
  @JsonKey(name: 'address_label')
  final String addressLabel;
  final String status;
  @JsonKey(name: 'estimated_arrival')
  final String? estimatedArrival;
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @JsonKey(name: 'total_amount')
  final num? totalAmount;
  @JsonKey(name: 'buyer_name')
  final String? buyerName;
  @JsonKey(name: 'address_lat')
  final double? addressLat;
  @JsonKey(name: 'address_lng')
  final double? addressLng;
  @JsonKey(name: 'requires_manual_navigation')
  final bool? requiresManualNavigation;
  @JsonKey(name: 'actual_arrival')
  final String? actualArrival;
  final List<RouteStopItemModel>? items;
  final String? notes;

  RouteStopModel({
    required this.stopId,
    required this.stopOrder,
    this.orderId,
    this.orderNumber,
    required this.recipientName,
    required this.addressLabel,
    required this.status,
    this.estimatedArrival,
    this.paymentMethod,
    this.totalAmount,
    this.buyerName,
    this.addressLat,
    this.addressLng,
    this.requiresManualNavigation,
    this.actualArrival,
    this.items,
    this.notes,
  });

  factory RouteStopModel.fromJson(Map<String, dynamic> json) =>
      _$RouteStopModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteStopModelToJson(this);

  RouteStop toEntity() {
    return RouteStop(
      stopId: stopId,
      stopOrder: stopOrder,
      orderId: orderId,
      orderNumber: orderNumber,
      recipientName: recipientName,
      addressLabel: addressLabel,
      status: status,
      estimatedArrival: estimatedArrival,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount?.toDouble(),
      buyerName: buyerName,
      addressLat: addressLat,
      addressLng: addressLng,
      requiresManualNavigation: requiresManualNavigation,
      actualArrival: actualArrival,
      items: items?.map((i) => i.toEntity()).toList(),
      notes: notes,
    );
  }
}

@JsonSerializable()
class RouteStopItemModel {
  final String productName;
  final int quantity;

  RouteStopItemModel({
    required this.productName,
    required this.quantity,
  });

  factory RouteStopItemModel.fromJson(Map<String, dynamic> json) =>
      _$RouteStopItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteStopItemModelToJson(this);

  RouteStopItem toEntity() {
    return RouteStopItem(
      productName: productName,
      quantity: quantity,
    );
  }
}
