// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preorder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreOrderModel _$PreOrderModelFromJson(Map<String, dynamic> json) =>
    PreOrderModel(
      activeHarvests: (json['active_harvests_count'] as num).toInt(),
      yourReservations: (json['your_reservations_count'] as num).toInt(),
      avgSavings: json['avg_savings'] as String,
      availableHarvests: (json['available_harvests'] as List<dynamic>)
          .map((e) => PreOrderHarvestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeReservations: (json['active_reservations'] as List<dynamic>)
          .map((e) =>
              PreOrderReservationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PreOrderModelToJson(PreOrderModel instance) =>
    <String, dynamic>{
      'active_harvests_count': instance.activeHarvests,
      'your_reservations_count': instance.yourReservations,
      'avg_savings': instance.avgSavings,
      'available_harvests':
          instance.availableHarvests.map((e) => e.toJson()).toList(),
      'active_reservations':
          instance.activeReservations.map((e) => e.toJson()).toList(),
    };

PreOrderHarvestModel _$PreOrderHarvestModelFromJson(
        Map<String, dynamic> json) =>
    PreOrderHarvestModel(
      id: json['id'] as String,
      title: json['title'] as String,
      farmerName: json['farmer_name'] as String,
      distance: json['distance'] as String,
      imageUrl: json['image_url'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      bookedQuantity: (json['booked_quantity'] as num).toDouble(),
      totalQuantity: (json['total_quantity'] as num).toDouble(),
      daysLeft: (json['days_left'] as num).toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$PreOrderHarvestModelToJson(
        PreOrderHarvestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'farmer_name': instance.farmerName,
      'distance': instance.distance,
      'image_url': instance.imageUrl,
      'price': instance.price,
      'unit': instance.unit,
      'booked_quantity': instance.bookedQuantity,
      'total_quantity': instance.totalQuantity,
      'days_left': instance.daysLeft,
      'status': instance.status,
    };

PreOrderReservationModel _$PreOrderReservationModelFromJson(
        Map<String, dynamic> json) =>
    PreOrderReservationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      farmerName: json['farmer_name'] as String,
      quantityStr: json['quantity_str'] as String,
      imageUrl: json['image_url'] as String,
      status: json['status'] as String,
      daysToHarvest: (json['days_to_harvest'] as num).toInt(),
    );

Map<String, dynamic> _$PreOrderReservationModelToJson(
        PreOrderReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'farmer_name': instance.farmerName,
      'quantity_str': instance.quantityStr,
      'image_url': instance.imageUrl,
      'status': instance.status,
      'days_to_harvest': instance.daysToHarvest,
    };
