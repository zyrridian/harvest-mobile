import 'package:equatable/equatable.dart';

class FarmerPreorderCampaign extends Equatable {
  final String id;
  final String farmerId;
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

  const FarmerPreorderCampaign({
    required this.id,
    required this.farmerId,
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
  });

  FarmerPreorderCampaign copyWith({
    String? id,
    String? farmerId,
    String? title,
    String? description,
    String? category,
    String? unit,
    double? pricePerUnit,
    int? minimumOrderQuantity,
    int? targetQuantity,
    int? currentBookedQuantity,
    double? depositPercentage,
    DateTime? estimatedHarvestDate,
    String? status,
    List<String>? images,
    bool? isScheduled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FarmerPreorderCampaign(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,
      targetQuantity: targetQuantity ?? this.targetQuantity,
      currentBookedQuantity:
          currentBookedQuantity ?? this.currentBookedQuantity,
      depositPercentage: depositPercentage ?? this.depositPercentage,
      estimatedHarvestDate: estimatedHarvestDate ?? this.estimatedHarvestDate,
      status: status ?? this.status,
      images: images ?? this.images,
      isScheduled: isScheduled ?? this.isScheduled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        farmerId,
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
      ];
}
