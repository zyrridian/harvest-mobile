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
  final int? totalPeopleReserved;
  final String? category;
  final int? minimumOrder;
  final int? userReservedQuantity;
  final int? successfulHarvests;
  final List<CommunityReservationInfo>? communityReservations;
  final String? profileImage;
  final bool? isScheduled;

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
    this.totalPeopleReserved,
    this.category,
    this.minimumOrder,
    this.userReservedQuantity,
    this.successfulHarvests,
    this.communityReservations,
    this.profileImage,
    this.isScheduled,
  });

  PreorderCampaign copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    String? farmerName,
    int? targetQuantity,
    int? currentReservations,
    DateTime? deadline,
    DateTime? estimatedHarvestDate,
    bool? depositRequired,
    double? depositAmount,
    String? status,
    double? price,
    String? unit,
    String? description,
    bool? hasReserved,
    double? distance,
    String? location,
    List<String>? images,
    List<PreorderReservationInfo>? reservations,
    int? totalPeopleReserved,
    String? category,
    int? minimumOrder,
    int? userReservedQuantity,
    int? successfulHarvests,
    List<CommunityReservationInfo>? communityReservations,
    String? profileImage,
    bool? isScheduled,
  }) {
    return PreorderCampaign(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      farmerName: farmerName ?? this.farmerName,
      targetQuantity: targetQuantity ?? this.targetQuantity,
      currentReservations: currentReservations ?? this.currentReservations,
      deadline: deadline ?? this.deadline,
      estimatedHarvestDate: estimatedHarvestDate ?? this.estimatedHarvestDate,
      depositRequired: depositRequired ?? this.depositRequired,
      depositAmount: depositAmount ?? this.depositAmount,
      status: status ?? this.status,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      hasReserved: hasReserved ?? this.hasReserved,
      distance: distance ?? this.distance,
      location: location ?? this.location,
      images: images ?? this.images,
      reservations: reservations ?? this.reservations,
      totalPeopleReserved: totalPeopleReserved ?? this.totalPeopleReserved,
      category: category ?? this.category,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      userReservedQuantity: userReservedQuantity ?? this.userReservedQuantity,
      successfulHarvests: successfulHarvests ?? this.successfulHarvests,
      communityReservations: communityReservations ?? this.communityReservations,
      profileImage: profileImage ?? this.profileImage,
      isScheduled: isScheduled ?? this.isScheduled,
    );
  }

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
        totalPeopleReserved,
        category,
        minimumOrder,
        userReservedQuantity,
        successfulHarvests,
        communityReservations,
        profileImage,
        isScheduled,
      ];
}

class CommunityReservationInfo extends Equatable {
  final String id;
  final String name;
  final String? profileImage;

  const CommunityReservationInfo({
    required this.id,
    required this.name,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, name, profileImage];
}

class PreorderReservationInfo extends Equatable {
  final String id;
  final String userId;
  final String buyerName;
  final int quantity;
  final String status;
  final double? totalPrice;
  final double? depositAmount;
  final String? paymentMethod;
  final String? deliveryMethod;
  final String? addressId;
  final String? fullAddress;
  final double? latitude;
  final double? longitude;

  const PreorderReservationInfo({
    required this.id,
    required this.userId,
    required this.buyerName,
    required this.quantity,
    required this.status,
    this.totalPrice,
    this.depositAmount,
    this.paymentMethod,
    this.deliveryMethod,
    this.addressId,
    this.fullAddress,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        buyerName,
        quantity,
        status,
        totalPrice,
        depositAmount,
        paymentMethod,
        deliveryMethod,
        addressId,
        fullAddress,
        latitude,
        longitude,
      ];
}
