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
      ];
}
