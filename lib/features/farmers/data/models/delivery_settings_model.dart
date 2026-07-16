import 'package:harvest_app/features/farmers/domain/entities/delivery_settings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_settings_model.g.dart';

@JsonSerializable()
class DeliverySettingsModel {
  @JsonKey(name: 'farmer_delivery_enabled')
  final bool farmerDeliveryEnabled;
  @JsonKey(name: 'base_fee')
  final num baseFee;
  @JsonKey(name: 'per_km_rate')
  final num perKmRate;
  @JsonKey(name: 'max_radius_km')
  final num maxRadiusKm;
  @JsonKey(name: 'min_order_for_free')
  final num? minOrderForFree;
  @JsonKey(name: 'cash_on_delivery_enabled')
  final bool cashOnDeliveryEnabled;
  final String? notes;

  DeliverySettingsModel({
    required this.farmerDeliveryEnabled,
    required this.baseFee,
    required this.perKmRate,
    required this.maxRadiusKm,
    this.minOrderForFree,
    required this.cashOnDeliveryEnabled,
    this.notes,
  });

  factory DeliverySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$DeliverySettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliverySettingsModelToJson(this);

  DeliverySettings toEntity() {
    return DeliverySettings(
      farmerDeliveryEnabled: farmerDeliveryEnabled,
      baseFee: baseFee.toDouble(),
      perKmRate: perKmRate.toDouble(),
      maxRadiusKm: maxRadiusKm.toDouble(),
      minOrderForFree: minOrderForFree?.toDouble() ?? 0.0,
      cashOnDeliveryEnabled: cashOnDeliveryEnabled,
      notes: notes,
    );
  }
}
