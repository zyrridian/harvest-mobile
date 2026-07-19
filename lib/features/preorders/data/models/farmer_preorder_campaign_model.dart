import 'package:json_annotation/json_annotation.dart';
import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign.dart';

part 'farmer_preorder_campaign_model.g.dart';

@JsonSerializable()
class FarmerPreorderCampaignModel {
  final String id;
  final String farmerId;
  final String title;
  final String? description;
  final String category;
  final String unit;

  @JsonKey(fromJson: _toDouble)
  final double pricePerUnit;

  final int minimumOrderQuantity;
  final int targetQuantity;
  final int currentBookedQuantity;

  @JsonKey(fromJson: _toDouble)
  final double depositPercentage;

  final DateTime estimatedHarvestDate;
  final String status;
  final List<String> images;
  final bool isScheduled;
  final DateTime createdAt;
  final DateTime updatedAt;

  FarmerPreorderCampaignModel({
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

  factory FarmerPreorderCampaignModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$FarmerPreorderCampaignModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FarmerPreorderCampaignModelToJson(this);

  static double _toDouble(Object? value) =>
      (value as num).toDouble();

  bool get depositRequired => depositPercentage > 0;

  String? get thumbnail =>
      images.isNotEmpty ? images.first : null;

  FarmerPreorderCampaign toEntity() {
    return FarmerPreorderCampaign(
      id: id,
      farmerId: farmerId,
      title: title,
      description: description,
      category: category,
      unit: unit,
      pricePerUnit: pricePerUnit,
      minimumOrderQuantity: minimumOrderQuantity,
      targetQuantity: targetQuantity,
      currentBookedQuantity: currentBookedQuantity,
      depositPercentage: depositPercentage,
      estimatedHarvestDate: estimatedHarvestDate,
      status: status,
      images: images,
      isScheduled: isScheduled,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}