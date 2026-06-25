import 'package:equatable/equatable.dart';

class RoutePlan extends Equatable {
  final String routeId;
  final String deliveryDate;
  final String status;
  final bool trackingEnabled;
  final int stopCount;
  final double totalDistanceKm;
  final int estimatedMinutes;
  final List<RouteStop> stops;

  const RoutePlan({
    required this.routeId,
    required this.deliveryDate,
    required this.status,
    required this.trackingEnabled,
    required this.stopCount,
    required this.totalDistanceKm,
    required this.estimatedMinutes,
    required this.stops,
  });

  @override
  List<Object?> get props => [
        routeId,
        deliveryDate,
        status,
        trackingEnabled,
        stopCount,
        totalDistanceKm,
        estimatedMinutes,
        stops,
      ];
}

class RouteStop extends Equatable {
  final String stopId;
  final int stopOrder;
  final String? orderId;
  final String? orderNumber;
  final String recipientName;
  final String addressLabel;
  final String status;
  final String? estimatedArrival;
  final String? paymentMethod;
  final double? totalAmount;
  final String? buyerName;
  final double? addressLat;
  final double? addressLng;
  final String? actualArrival;
  final List<RouteStopItem>? items;
  final String? notes;

  const RouteStop({
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
    this.actualArrival,
    this.items,
    this.notes,
  });

  @override
  List<Object?> get props => [
        stopId,
        stopOrder,
        orderId,
        orderNumber,
        recipientName,
        addressLabel,
        status,
        estimatedArrival,
        paymentMethod,
        totalAmount,
        buyerName,
        addressLat,
        addressLng,
        actualArrival,
        items,
        notes,
      ];
}

class RouteStopItem extends Equatable {
  final String productName;
  final int quantity;

  const RouteStopItem({
    required this.productName,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productName, quantity];
}
