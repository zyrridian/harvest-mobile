// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerProductResponseModel _$FarmerProductResponseModelFromJson(
        Map<String, dynamic> json) =>
    FarmerProductResponseModel(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => FarmerProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FarmerProductResponseModelToJson(
        FarmerProductResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

FarmerProductModel _$FarmerProductModelFromJson(Map<String, dynamic> json) =>
    FarmerProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as num,
      unit: json['unit'] as String,
      stock: (json['stock'] as num).toInt(),
      isAvailable: json['is_available'] as bool,
      imageUrl: json['image_url'] as String?,
      ordersCount: (json['orders_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FarmerProductModelToJson(FarmerProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'unit': instance.unit,
      'stock': instance.stock,
      'is_available': instance.isAvailable,
      'image_url': instance.imageUrl,
      'orders_count': instance.ordersCount,
    };
