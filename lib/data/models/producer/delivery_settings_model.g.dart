// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliverySettingsModel _$DeliverySettingsModelFromJson(
        Map<String, dynamic> json) =>
    DeliverySettingsModel(
      farmerDeliveryEnabled: json['farmer_delivery_enabled'] as bool,
      baseFee: json['base_fee'] as num,
      perKmRate: json['per_km_rate'] as num,
      maxRadiusKm: json['max_radius_km'] as num,
      minOrderForFree: json['min_order_for_free'] as num?,
      cashOnDeliveryEnabled: json['cash_on_delivery_enabled'] as bool,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$DeliverySettingsModelToJson(
        DeliverySettingsModel instance) =>
    <String, dynamic>{
      'farmer_delivery_enabled': instance.farmerDeliveryEnabled,
      'base_fee': instance.baseFee,
      'per_km_rate': instance.perKmRate,
      'max_radius_km': instance.maxRadiusKm,
      'min_order_for_free': instance.minOrderForFree,
      'cash_on_delivery_enabled': instance.cashOnDeliveryEnabled,
      'notes': instance.notes,
    };
