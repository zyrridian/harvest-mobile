import 'package:equatable/equatable.dart';

enum HarvestStatus {
  upcoming,
  readyToHarvest,
  harvesting,
  completed,
  cancelled
}

class HarvestSchedule extends Equatable {
  final String id;
  final String farmerId;
  final String farmerName;
  final String farmerProfileImage;
  final String productId;
  final String productName;
  final String productImage;
  final String category;
  final DateTime plannedHarvestDate;
  final DateTime? actualHarvestDate;
  final int estimatedQuantity; // in the product's unit
  final String unit;
  final double estimatedPricePerUnit;
  final HarvestStatus status;
  final bool acceptsPreOrders;
  final int preOrderCount; // How many users have pre-ordered
  final int preOrderQuantity; // Total quantity pre-ordered
  final int availableQuantity; // Remaining quantity for pre-order
  final double farmerLatitude;
  final double farmerLongitude;
  final double? distanceFromUser; // Distance in km
  final bool isOrganic;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HarvestSchedule({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmerProfileImage,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.category,
    required this.plannedHarvestDate,
    this.actualHarvestDate,
    required this.estimatedQuantity,
    required this.unit,
    required this.estimatedPricePerUnit,
    required this.status,
    this.acceptsPreOrders = true,
    this.preOrderCount = 0,
    this.preOrderQuantity = 0,
    required this.availableQuantity,
    required this.farmerLatitude,
    required this.farmerLongitude,
    this.distanceFromUser,
    this.isOrganic = false,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Days remaining until harvest
  int get daysUntilHarvest {
    return plannedHarvestDate.difference(DateTime.now()).inDays;
  }

  /// Whether harvest is happening today
  bool get isHarvestingToday {
    final now = DateTime.now();
    return plannedHarvestDate.year == now.year &&
        plannedHarvestDate.month == now.month &&
        plannedHarvestDate.day == now.day;
  }

  /// Whether pre-orders are still available
  bool get canPreOrder {
    return acceptsPreOrders &&
        availableQuantity > 0 &&
        status == HarvestStatus.upcoming;
  }

  /// Percentage of estimated quantity already pre-ordered
  double get preOrderPercentage {
    if (estimatedQuantity == 0) return 0;
    return (preOrderQuantity / estimatedQuantity) * 100;
  }

  @override
  List<Object?> get props => [
        id,
        farmerId,
        farmerName,
        farmerProfileImage,
        productId,
        productName,
        productImage,
        category,
        plannedHarvestDate,
        actualHarvestDate,
        estimatedQuantity,
        unit,
        estimatedPricePerUnit,
        status,
        acceptsPreOrders,
        preOrderCount,
        preOrderQuantity,
        availableQuantity,
        farmerLatitude,
        farmerLongitude,
        distanceFromUser,
        isOrganic,
        description,
        createdAt,
        updatedAt,
      ];
}

/// Represents a farmer's upcoming harvest schedule summary (for notifications/alerts)
class UpcomingHarvestAlert extends Equatable {
  final String farmerId;
  final String farmerName;
  final String farmerProfileImage;
  final double distanceKm;
  final int upcomingHarvestCount;
  final DateTime nextHarvestDate;
  final List<String> products; // Product names
  final bool isSubscribed; // User subscribed to this farmer

  const UpcomingHarvestAlert({
    required this.farmerId,
    required this.farmerName,
    required this.farmerProfileImage,
    required this.distanceKm,
    required this.upcomingHarvestCount,
    required this.nextHarvestDate,
    required this.products,
    this.isSubscribed = false,
  });

  @override
  List<Object?> get props => [
        farmerId,
        farmerName,
        farmerProfileImage,
        distanceKm,
        upcomingHarvestCount,
        nextHarvestDate,
        products,
        isSubscribed,
      ];
}
