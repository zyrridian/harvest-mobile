import 'package:equatable/equatable.dart';

class CreatePreorderCampaignParams extends Equatable {
  final String title;
  final String description;
  final String unit;
  final double pricePerUnit;
  final int targetQuantity;
  final DateTime estimatedHarvestDate;
  final int minimumOrderQuantity;
  final int depositPercentage;
  final String status;
  final List<String>? images;

  const CreatePreorderCampaignParams({
    required this.title,
    required this.description,
    required this.unit,
    required this.pricePerUnit,
    required this.targetQuantity,
    required this.estimatedHarvestDate,
    required this.minimumOrderQuantity,
    required this.depositPercentage,
    this.status = 'ACTIVE',
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "unit": unit,
      "pricePerUnit": pricePerUnit,
      "targetQuantity": targetQuantity,
      "estimatedHarvestDate": estimatedHarvestDate.toIso8601String(),
      "minimumOrderQuantity": minimumOrderQuantity,
      "depositPercentage": depositPercentage,
      "status": status,
      if (images != null) "images": images,
    };
  }

  @override
  List<Object?> get props => [
        title,
        description,
        unit,
        pricePerUnit,
        targetQuantity,
        estimatedHarvestDate,
        minimumOrderQuantity,
        depositPercentage,
        status,
        images,
      ];
}
