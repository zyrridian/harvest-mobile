import 'package:harvest_app/domain/entities/preorder_campaign.dart';

class PreorderCampaignModel extends PreorderCampaign {
  const PreorderCampaignModel({
    required super.id,
    required super.productId,
    super.productName,
    super.productImage,
    super.farmerName,
    required super.targetQuantity,
    required super.currentReservations,
    required super.deadline,
    required super.estimatedHarvestDate,
    required super.depositRequired,
    required super.depositAmount,
    super.status,
    super.price,
    super.unit,
    super.description,
    super.hasReserved,
    super.distance,
    super.location,
  });

  factory PreorderCampaignModel.fromJson(Map<String, dynamic> json) {
    return PreorderCampaignModel(
      id: json['id'] ?? json['campaignId'] ?? '',
      productId: json['productId'] ?? json['farmerId'] ?? (json['product']?['id']) ?? '',
      productName: json['title'] ?? json['productName'] ?? json['product']?['name'],
      productImage: json['productImage'] ?? json['product']?['image'],
      farmerName: json['farmerName'],
      targetQuantity: json['targetQuantity'] ?? 0,
      currentReservations: json['currentBookedQuantity'] ?? json['currentReservations'] ?? 0,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : (json['estimatedHarvestDate'] != null 
              ? DateTime.parse(json['estimatedHarvestDate']) 
              : DateTime.now()),
      estimatedHarvestDate: json['estimatedHarvestDate'] != null
          ? DateTime.parse(json['estimatedHarvestDate'])
          : DateTime.now(),
      depositRequired: json['depositRequired'] ?? ((json['depositPercentage'] ?? 0) > 0),
      depositAmount: (json['depositAmount'] ?? json['depositPercentage'] ?? 0).toDouble(),
      status: json['status'],
      price: (json['price'] ?? 0).toDouble(),
      unit: json['unit'],
      description: json['description'],
      hasReserved: json['hasReserved'],
      distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'targetQuantity': targetQuantity,
      'currentReservations': currentReservations,
      'deadline': deadline.toIso8601String(),
      'estimatedHarvestDate': estimatedHarvestDate.toIso8601String(),
      'depositRequired': depositRequired,
      'depositAmount': depositAmount,
      'status': status,
      'price': price,
      'unit': unit,
      'description': description,
      'hasReserved': hasReserved,
      'distance': distance,
      'location': location,
    };
  }
}
