// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_farmer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NearbyFarmerProductImpl _$$NearbyFarmerProductImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbyFarmerProductImpl(
      name: json['name'] as String,
    );

Map<String, dynamic> _$$NearbyFarmerProductImplToJson(
        _$NearbyFarmerProductImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

_$NearbyFarmerDataImpl _$$NearbyFarmerDataImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbyFarmerDataImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      distance: (json['distance'] as num).toDouble(),
      category: json['category'] as String,
      subCategory: json['subCategory'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      products: (json['products'] as List<dynamic>)
          .map((e) => NearbyFarmerProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      extraProductsCount: (json['extraProductsCount'] as num).toInt(),
      statusText: json['statusText'] as String,
      statusSubText: json['statusSubText'] as String,
      isOpen: json['isOpen'] as bool,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      iconPath: json['iconPath'] as String,
    );

Map<String, dynamic> _$$NearbyFarmerDataImplToJson(
        _$NearbyFarmerDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'distance': instance.distance,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'tags': instance.tags,
      'products': instance.products,
      'extraProductsCount': instance.extraProductsCount,
      'statusText': instance.statusText,
      'statusSubText': instance.statusSubText,
      'isOpen': instance.isOpen,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'iconPath': instance.iconPath,
    };
