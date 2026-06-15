import 'package:freezed_annotation/freezed_annotation.dart';

part 'preorder_state.freezed.dart';

class PreOrderHarvest {
  final String id;
  final String title;
  final String farmerName;
  final String distance;
  final String imageUrl;
  final double price;
  final String unit;
  final double bookedQuantity;
  final double totalQuantity;
  final int daysLeft;
  final String status;

  PreOrderHarvest({
    required this.id,
    required this.title,
    required this.farmerName,
    required this.distance,
    required this.imageUrl,
    required this.price,
    required this.unit,
    required this.bookedQuantity,
    required this.totalQuantity,
    required this.daysLeft,
    required this.status,
  });

  double get progressPercentage => (bookedQuantity / totalQuantity) * 100;
  double get remainingQuantity => totalQuantity - bookedQuantity;
}

class PreOrderReservation {
  final String id;
  final String title;
  final String farmerName;
  final String quantityStr;
  final String imageUrl;
  final String status;
  final int daysToHarvest;

  PreOrderReservation({
    required this.id,
    required this.title,
    required this.farmerName,
    required this.quantityStr,
    required this.imageUrl,
    required this.status,
    required this.daysToHarvest,
  });
}

class PreOrderData {
  final int activeHarvests;
  final int yourReservations;
  final String avgSavings;
  final List<PreOrderHarvest> availableHarvests;
  final List<PreOrderReservation> activeReservations;

  PreOrderData({
    required this.activeHarvests,
    required this.yourReservations,
    required this.avgSavings,
    required this.availableHarvests,
    required this.activeReservations,
  });
}

@freezed
class PreOrderState with _$PreOrderState {
  const factory PreOrderState.initial() = _Initial;
  const factory PreOrderState.loading() = _Loading;
  const factory PreOrderState.data(PreOrderData data) = _Data;
  const factory PreOrderState.error(String message) = _Error;
}
