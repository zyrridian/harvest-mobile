import 'package:equatable/equatable.dart';

class DeliverySettings extends Equatable {
  final bool farmerDeliveryEnabled;
  final double baseFee;
  final double perKmRate;
  final double maxRadiusKm;
  final double minOrderForFree;
  final bool cashOnDeliveryEnabled;

  const DeliverySettings({
    required this.farmerDeliveryEnabled,
    required this.baseFee,
    required this.perKmRate,
    required this.maxRadiusKm,
    required this.minOrderForFree,
    required this.cashOnDeliveryEnabled,
  });

  @override
  List<Object?> get props => [
        farmerDeliveryEnabled,
        baseFee,
        perKmRate,
        maxRadiusKm,
        minOrderForFree,
        cashOnDeliveryEnabled,
      ];
}
