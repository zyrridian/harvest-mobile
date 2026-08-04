import 'package:json_annotation/json_annotation.dart';
import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign_detail.dart';

part 'farmer_preorder_campaign_detail_model.g.dart';

@JsonSerializable()
class FarmerPreorderCampaignDetailModel {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String unit;
  
  @JsonKey(fromJson: _toDouble)
  final double pricePerUnit;
  
  final int minimumOrderQuantity;
  final int targetQuantity;
  final int currentBookedQuantity;
  
  final DateTime estimatedHarvestDate;
  final String status;
  final List<String> images;
  final bool isScheduled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalPeopleReserved;
  final List<FarmerPreorderReservationModel> reservations;

  FarmerPreorderCampaignDetailModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.unit,
    required this.pricePerUnit,
    required this.minimumOrderQuantity,
    required this.targetQuantity,
    required this.currentBookedQuantity,
    required this.estimatedHarvestDate,
    required this.status,
    required this.images,
    required this.isScheduled,
    required this.createdAt,
    required this.updatedAt,
    required this.totalPeopleReserved,
    required this.reservations,
  });

  factory FarmerPreorderCampaignDetailModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerPreorderCampaignDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerPreorderCampaignDetailModelToJson(this);

  static double _toDouble(Object? value) => (value as num).toDouble();

  FarmerPreorderCampaignDetail toEntity() {
    return FarmerPreorderCampaignDetail(
      id: id,
      title: title,
      description: description,
      category: category,
      unit: unit,
      pricePerUnit: pricePerUnit,
      minimumOrderQuantity: minimumOrderQuantity,
      targetQuantity: targetQuantity,
      currentBookedQuantity: currentBookedQuantity,
      estimatedHarvestDate: estimatedHarvestDate,
      status: status,
      images: images,
      isScheduled: isScheduled,
      createdAt: createdAt,
      updatedAt: updatedAt,
      totalPeopleReserved: totalPeopleReserved,
      reservations: reservations.map((r) => r.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class FarmerPreorderReservationModel {
  final String id;
  final int quantity;
  
  @JsonKey(fromJson: _toDouble)
  final double totalPrice;
  
  final String status;
  final String? paymentMethod;
  final String? deliveryMethod;
  final String? addressId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? fullAddress;
  
  @JsonKey(fromJson: _nullableToDouble)
  final double? latitude;
  
  @JsonKey(fromJson: _nullableToDouble)
  final double? longitude;
  
  final String buyerId;
  final String buyerName;
  final String? buyerAvatarUrl;
  final String? conversationId;

  FarmerPreorderReservationModel({
    required this.id,
    required this.quantity,
    required this.totalPrice,
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

  factory FarmerPreorderReservationModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerPreorderReservationModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerPreorderReservationModelToJson(this);

  static double _toDouble(Object? value) => (value as num).toDouble();
  static double? _nullableToDouble(Object? value) => value != null ? (value as num).toDouble() : null;

  FarmerPreorderReservation toEntity() {
    return FarmerPreorderReservation(
      id: id,
      quantity: quantity,
      totalPrice: totalPrice,
      status: status,
      paymentMethod: paymentMethod,
      deliveryMethod: deliveryMethod,
      addressId: addressId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      fullAddress: fullAddress,
      latitude: latitude,
      longitude: longitude,
      buyerId: buyerId,
      buyerName: buyerName,
      buyerAvatarUrl: buyerAvatarUrl,
      conversationId: conversationId,
    );
  }
}
