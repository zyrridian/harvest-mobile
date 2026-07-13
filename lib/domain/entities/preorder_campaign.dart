import 'package:equatable/equatable.dart';

class PreorderCampaign extends Equatable {
  final String id;
  final String productId;
  final String? productName;
  final String? productImage;
  final String? farmerName;
  final int targetQuantity;
  final int currentReservations;
  final DateTime deadline;
  final DateTime estimatedHarvestDate;
  final bool depositRequired;
  final double depositAmount;
  final String? status;
  final double? price;
  final String? unit;
  final String? description;
  final bool? hasReserved;
  final double? distance;
  final String? location;
  final List<String>? images;
  final List<PreorderReservationInfo>? reservations;

  const PreorderCampaign({
    required this.id,
    required this.productId,
    this.productName,
    this.productImage,
    this.farmerName,
    required this.targetQuantity,
    required this.currentReservations,
    required this.deadline,
    required this.estimatedHarvestDate,
    required this.depositRequired,
    required this.depositAmount,
    this.status,
    this.price,
    this.unit,
    this.description,
    this.hasReserved,
    this.distance,
    this.location,
    this.images,
    this.reservations,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        productImage,
        farmerName,
        targetQuantity,
        currentReservations,
        deadline,
        estimatedHarvestDate,
        depositRequired,
        depositAmount,
        status,
        price,
        unit,
        description,
        hasReserved,
        distance,
        location,
        images,
        reservations,
      ];
}

class PreorderReservationInfo extends Equatable {
  final String id;
  final String userId;
  final int quantity;
  final String status;

  const PreorderReservationInfo({
    required this.id,
    required this.userId,
    required this.quantity,
    required this.status,
  });

  @override
  List<Object?> get props => [id, userId, quantity, status];
}
