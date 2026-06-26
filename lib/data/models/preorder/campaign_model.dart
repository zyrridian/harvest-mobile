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
  });

  factory PreorderCampaignModel.fromJson(Map<String, dynamic> json) {
    return PreorderCampaignModel(
      id: json['id'] ?? json['campaignId'] ?? '',
      productId: json['productId'] ?? (json['product']?['id']) ?? '',
      productName: json['product']?['name'],
      productImage: json['product']?['image'],
      farmerName: json['farmerName'],
      targetQuantity: json['targetQuantity'] ?? 0,
      currentReservations: json['currentReservations'] ?? 0,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : DateTime.now(),
      estimatedHarvestDate: json['estimatedHarvestDate'] != null
          ? DateTime.parse(json['estimatedHarvestDate'])
          : DateTime.now(),
      depositRequired: json['depositRequired'] ?? false,
      depositAmount: (json['depositAmount'] ?? 0).toDouble(),
      status: json['status'],
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
    };
  }
}
