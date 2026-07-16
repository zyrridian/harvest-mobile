import 'package:harvest_app/features/preorders/domain/entities/preorder.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preorder_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PreOrderModel {
  @JsonKey(name: 'active_harvests_count')
  final int activeHarvests;
  @JsonKey(name: 'your_reservations_count')
  final int yourReservations;
  @JsonKey(name: 'avg_savings')
  final String avgSavings;
  @JsonKey(name: 'available_harvests')
  final List<PreOrderHarvestModel> availableHarvests;
  @JsonKey(name: 'active_reservations')
  final List<PreOrderReservationModel> activeReservations;

  PreOrderModel({
    required this.activeHarvests,
    required this.yourReservations,
    required this.avgSavings,
    required this.availableHarvests,
    required this.activeReservations,
  });

  factory PreOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PreOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreOrderModelToJson(this);

  PreOrderResponseEntity toEntity() {
    return PreOrderResponseEntity(
      activeHarvests: activeHarvests,
      yourReservations: yourReservations,
      avgSavings: avgSavings,
      availableHarvests: availableHarvests.map((e) => e.toEntity()).toList(),
      activeReservations: activeReservations.map((e) => e.toEntity()).toList(),
    );
  }

  factory PreOrderModel.fromEntity(PreOrderResponseEntity entity) {
    return PreOrderModel(
      activeHarvests: entity.activeHarvests,
      yourReservations: entity.yourReservations,
      avgSavings: entity.avgSavings,
      availableHarvests: entity.availableHarvests
          .map((e) => PreOrderHarvestModel.fromEntity(e))
          .toList(),
      activeReservations: entity.activeReservations
          .map((e) => PreOrderReservationModel.fromEntity(e))
          .toList(),
    );
  }
}

@JsonSerializable()
class PreOrderHarvestModel {
  final String id;
  final String title;
  @JsonKey(name: 'farmer_name')
  final String farmerName;
  final String distance;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final double price;
  final String unit;
  @JsonKey(name: 'booked_quantity')
  final double bookedQuantity;
  @JsonKey(name: 'total_quantity')
  final double totalQuantity;
  @JsonKey(name: 'days_left')
  final int daysLeft;
  final String status;

  PreOrderHarvestModel({
    required this.id,
    required this.title,
    required this.farmerName,
    required this.distance,
    required this.imageUrl,
    required this.price,
    required this.unit,
    required this.bookedQuantity,
    required this.totalQuantity,
    required this.daysLeft,
    required this.status,
  });

  factory PreOrderHarvestModel.fromJson(Map<String, dynamic> json) =>
      _$PreOrderHarvestModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreOrderHarvestModelToJson(this);

  PreOrderHarvest toEntity() {
    return PreOrderHarvest(
      id: id,
      title: title,
      farmerName: farmerName,
      distance: distance,
      imageUrl: imageUrl,
      price: price,
      unit: unit,
      bookedQuantity: bookedQuantity,
      totalQuantity: totalQuantity,
      daysLeft: daysLeft,
      status: status,
    );
  }

  factory PreOrderHarvestModel.fromEntity(PreOrderHarvest harvest) {
    return PreOrderHarvestModel(
      id: harvest.id,
      title: harvest.title,
      farmerName: harvest.farmerName,
      distance: harvest.distance,
      imageUrl: harvest.imageUrl,
      price: harvest.price,
      unit: harvest.unit,
      bookedQuantity: harvest.bookedQuantity,
      totalQuantity: harvest.totalQuantity,
      daysLeft: harvest.daysLeft,
      status: harvest.status,
    );
  }
}

@JsonSerializable()
class PreOrderReservationModel {
  final String id;
  @JsonKey(name: 'campaign_id')
  final String campaignId;
  @JsonKey(name: 'product_id')
  final String productId;
  final String title;
  @JsonKey(name: 'farmer_name')
  final String farmerName;
  @JsonKey(name: 'quantity_str')
  final String quantityStr;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final String status;
  @JsonKey(name: 'days_to_harvest')
  final int daysToHarvest;

  PreOrderReservationModel({
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

  factory PreOrderReservationModel.fromJson(Map<String, dynamic> json) =>
      _$PreOrderReservationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreOrderReservationModelToJson(this);

  PreOrderReservation toEntity() {
    return PreOrderReservation(
      id: id,
      campaignId: campaignId,
      productId: productId,
      title: title,
      farmerName: farmerName,
      quantityStr: quantityStr,
      imageUrl: imageUrl,
      status: status,
      daysToHarvest: daysToHarvest,
    );
  }

  factory PreOrderReservationModel.fromEntity(PreOrderReservation res) {
    return PreOrderReservationModel(
      id: res.id,
      campaignId: res.campaignId,
      productId: res.productId,
      title: res.title,
      farmerName: res.farmerName,
      quantityStr: res.quantityStr,
      imageUrl: res.imageUrl,
      status: res.status,
      daysToHarvest: res.daysToHarvest,
    );
  }
}
