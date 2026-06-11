// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerModel _$FarmerModelFromJson(Map<String, dynamic> json) => FarmerModel(
      id: json['id'] as String,
      farmerId: json['farmer_id'] as String,
      farmer: InnerFarmerModel.fromJson(json['farmer'] as Map<String, dynamic>),
      name: json['name'] as String,
      description: json['description'] as String,
      whatWeSell: json['what_we_sell'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FarmerModelToJson(FarmerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmer_id': instance.farmerId,
      'farmer': instance.farmer.toJson(),
      'name': instance.name,
      'description': instance.description,
      'what_we_sell': instance.whatWeSell,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'image_url': instance.imageUrl,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'distance': instance.distance,
    };

InnerFarmerModel _$InnerFarmerModelFromJson(Map<String, dynamic> json) =>
    InnerFarmerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profile_image'] as String?,
      isVerified: json['is_verified'] as bool,
      rating: (json['rating'] as num).toDouble(),
      city: json['city'] as String,
    );

Map<String, dynamic> _$InnerFarmerModelToJson(InnerFarmerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_image': instance.profileImage,
      'is_verified': instance.isVerified,
      'rating': instance.rating,
      'city': instance.city,
    };
