import 'package:equatable/equatable.dart';

enum PreOrderStatus {
  pending, // Waiting for harvest
  confirmed, // Farmer confirmed the pre-order
  readyForPickup, // Harvest complete, ready
  shipped, // Being delivered
  completed, // Delivered to customer
  cancelled, // Cancelled by user or farmer
  refunded // Refunded
}

enum DeliveryMethod {
  pickup, // Customer picks up from farmer
  delivery, // Farmer delivers to customer
  meetup // Meet at agreed location
}

class PreOrder extends Equatable {
  final String id;
  final String userId;
  final String harvestScheduleId;
  final String farmerId;
  final String farmerName;
  final String farmerProfileImage;
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final String unit;
  final double pricePerUnit;
  final double totalPrice;
  final PreOrderStatus status;
  final DateTime harvestDate;
  final DeliveryMethod deliveryMethod;
  final String? deliveryAddressId;
  final String? deliveryAddress;
  final String? pickupLocation;
  final DateTime? estimatedDeliveryDate;
  final String? notes;
  final String? farmerNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PreOrder({
    required this.id,
    required this.userId,
    required this.harvestScheduleId,
    required this.farmerId,
    required this.farmerName,
    required this.farmerProfileImage,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.totalPrice,
    required this.status,
    required this.harvestDate,
    required this.deliveryMethod,
    this.deliveryAddressId,
    this.deliveryAddress,
    this.pickupLocation,
    this.estimatedDeliveryDate,
    this.notes,
    this.farmerNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Days until harvest
  int get daysUntilHarvest {
    return harvestDate.difference(DateTime.now()).inDays;
  }

  /// Check if pre-order can be cancelled
  bool get canCancel {
    return status == PreOrderStatus.pending ||
        status == PreOrderStatus.confirmed;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        harvestScheduleId,
        farmerId,
        farmerName,
        farmerProfileImage,
        productId,
        productName,
        productImage,
        quantity,
        unit,
        pricePerUnit,
        totalPrice,
        status,
        harvestDate,
        deliveryMethod,
        deliveryAddressId,
        deliveryAddress,
        pickupLocation,
        estimatedDeliveryDate,
        notes,
        farmerNotes,
        createdAt,
        updatedAt,
      ];
}

/// Summary of user's pre-orders
class PreOrderSummary extends Equatable {
  final int totalPending;
  final int totalConfirmed;
  final int totalCompleted;
  final int upcomingThisWeek;
  final double totalSpent;

  const PreOrderSummary({
    required this.totalPending,
    required this.totalConfirmed,
    required this.totalCompleted,
    required this.upcomingThisWeek,
    required this.totalSpent,
  });

  @override
  List<Object?> get props => [
        totalPending,
        totalConfirmed,
        totalCompleted,
        upcomingThisWeek,
        totalSpent,
      ];
}
