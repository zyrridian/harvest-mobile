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

_$NearbyFarmerCabangImpl _$$NearbyFarmerCabangImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbyFarmerCabangImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      whatWeSell: json['whatWeSell'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      operatingHours: json['operatingHours'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$NearbyFarmerCabangImplToJson(
        _$NearbyFarmerCabangImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'whatWeSell': instance.whatWeSell,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'imageUrl': instance.imageUrl,
      'isActive': instance.isActive,
      'tags': instance.tags,
      'operatingHours': instance.operatingHours,
      'distance': instance.distance,
    };

_$NearbyFarmerMainLocationImpl _$$NearbyFarmerMainLocationImplFromJson(
        Map<String, dynamic> json) =>
    _$NearbyFarmerMainLocationImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$$NearbyFarmerMainLocationImplToJson(
        _$NearbyFarmerMainLocationImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
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
      mainLocation: json['mainLocation'] == null
          ? null
          : NearbyFarmerMainLocation.fromJson(
              json['mainLocation'] as Map<String, dynamic>),
      cabang: (json['cabang'] as List<dynamic>?)
              ?.map(
                  (e) => NearbyFarmerCabang.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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
      'mainLocation': instance.mainLocation,
      'cabang': instance.cabang,
    };
