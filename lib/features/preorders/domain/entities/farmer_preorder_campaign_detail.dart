import 'package:equatable/equatable.dart';

class FarmerPreorderCampaignDetail extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String unit;
  final double pricePerUnit;
  final int minimumOrderQuantity;
  final int targetQuantity;
  final int currentBookedQuantity;
  final double depositPercentage;
  final DateTime estimatedHarvestDate;
  final String status;
  final List<String> images;
  final bool isScheduled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalPeopleReserved;
  final List<FarmerPreorderReservation> reservations;

  const FarmerPreorderCampaignDetail({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.unit,
    required this.pricePerUnit,
    required this.minimumOrderQuantity,
    required this.targetQuantity,
    required this.currentBookedQuantity,
    required this.depositPercentage,
    required this.estimatedHarvestDate,
    required this.status,
    required this.images,
    required this.isScheduled,
    required this.createdAt,
    required this.updatedAt,
    required this.totalPeopleReserved,
    required this.reservations,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        unit,
        pricePerUnit,
        minimumOrderQuantity,
        targetQuantity,
        currentBookedQuantity,
        depositPercentage,
        estimatedHarvestDate,
        status,
        images,
        isScheduled,
        createdAt,
        updatedAt,
        totalPeopleReserved,
        reservations,
      ];
}

class FarmerPreorderReservation extends Equatable {
  final String id;
  final int quantity;
  final double totalPrice;
  final double depositAmount;
  final String status;
  final String? paymentMethod;
  final String? deliveryMethod;
  final String? addressId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? fullAddress;
  final double? latitude;
  final double? longitude;
  final String buyerId;
  final String buyerName;
  final String? buyerAvatarUrl;
  final String? conversationId;

  const FarmerPreorderReservation({
    required this.id,
    required this.quantity,
    required this.totalPrice,
    required this.depositAmount,
    required this.status,
    this.paymentMethod,
    this.deliveryMethod,
    this.addressId,
    required this.createdAt,
    required this.updatedAt,
    this.fullAddress,
    this.latitude,
    this.longitude,
    required this.buyerId,
    required this.buyerName,
    this.buyerAvatarUrl,
    this.conversationId,
  });

  @override
  List<Object?> get props => [
        id,
        quantity,
        totalPrice,
        depositAmount,
        status,
        paymentMethod,
        deliveryMethod,
        addressId,
        createdAt,
        updatedAt,
        fullAddress,
        latitude,
        longitude,
        buyerId,
        buyerName,
        buyerAvatarUrl,
        conversationId,
      ];
}
