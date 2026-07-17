import 'package:equatable/equatable.dart';

class PreOrderHarvest extends Equatable {
  final String id;
  final String title;
  final String farmerName;
  final String? distance;
  final String imageUrl;
  final double price;
  final String unit;
  final double bookedQuantity;
  final double totalQuantity;
  final int daysLeft;
  final String status;
  final int totalPeopleReserved;
  final bool isScheduled;

  const PreOrderHarvest({
    required this.id,
    required this.title,
    required this.farmerName,
    this.distance,
    required this.imageUrl,
    required this.price,
    required this.unit,
    required this.bookedQuantity,
    required this.totalQuantity,
    required this.daysLeft,
    required this.status,
    required this.totalPeopleReserved,
    this.isScheduled = false,
  });

  PreOrderHarvest copyWith({
    String? id,
    String? title,
    String? farmerName,
    String? distance,
    String? imageUrl,
    double? price,
    String? unit,
    double? bookedQuantity,
    double? totalQuantity,
    int? daysLeft,
    String? status,
    int? totalPeopleReserved,
    bool? isScheduled,
  }) {
    return PreOrderHarvest(
      id: id ?? this.id,
      title: title ?? this.title,
      farmerName: farmerName ?? this.farmerName,
      distance: distance ?? this.distance,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      bookedQuantity: bookedQuantity ?? this.bookedQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      daysLeft: daysLeft ?? this.daysLeft,
      status: status ?? this.status,
      totalPeopleReserved: totalPeopleReserved ?? this.totalPeopleReserved,
      isScheduled: isScheduled ?? this.isScheduled,
    );
  }

  double get progressPercentage =>
      totalQuantity > 0 ? (bookedQuantity / totalQuantity) * 100 : 0;
  double get remainingQuantity => totalQuantity - bookedQuantity;

  @override
  List<Object?> get props => [
        id,
        title,
        farmerName,
        distance,
        imageUrl,
        price,
        unit,
        bookedQuantity,
        totalQuantity,
        daysLeft,
        status,
        totalPeopleReserved,
        isScheduled,
      ];
}

class PreOrderReservation extends Equatable {
  final String id;
  final String campaignId;
  final String productId;
  final String title;
  final String farmerName;
  final String quantityStr;
  final String imageUrl;
  final String status;
  final int daysToHarvest;

  const PreOrderReservation({
    required this.id,
    required this.campaignId,
    required this.productId,
    required this.title,
    required this.farmerName,
    required this.quantityStr,
    required this.imageUrl,
    required this.status,
    required this.daysToHarvest,
  });

  @override
  List<Object?> get props => [
        id,
        campaignId,
        productId,
        title,
        farmerName,
        quantityStr,
        imageUrl,
        status,
        daysToHarvest,
      ];
}

class PreOrderResponseEntity extends Equatable {
  final int activeHarvests;
  final int yourReservations;
  final String avgSavings;
  final List<PreOrderHarvest> availableHarvests;
  final List<PreOrderReservation> activeReservations;

  const PreOrderResponseEntity({
    required this.activeHarvests,
    required this.yourReservations,
    required this.avgSavings,
    required this.availableHarvests,
    required this.activeReservations,
  });

  @override
  List<Object?> get props => [
        activeHarvests,
        yourReservations,
        avgSavings,
        availableHarvests,
        activeReservations,
      ];
}
