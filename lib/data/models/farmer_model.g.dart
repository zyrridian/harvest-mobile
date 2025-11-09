// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerModel _$FarmerModelFromJson(Map<String, dynamic> json) => FarmerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      profileImage: json['profile_image'] as String,
      coverImage: json['cover_image'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      rating: (json['rating'] as num).toDouble(),
      totalReviews: (json['total_reviews'] as num).toInt(),
      totalProducts: (json['total_products'] as num).toInt(),
      specialties: (json['specialties'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isVerified: json['is_verified'] as bool,
      hasMapFeature: json['has_map_feature'] as bool,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      joinedDate: json['joined_date'] as String,
      isOnline: json['is_online'] as bool,
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FarmerModelToJson(FarmerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'profile_image': instance.profileImage,
      'cover_image': instance.coverImage,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'rating': instance.rating,
      'total_reviews': instance.totalReviews,
      'total_products': instance.totalProducts,
      'specialties': instance.specialties,
      'is_verified': instance.isVerified,
      'has_map_feature': instance.hasMapFeature,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'joined_date': instance.joinedDate,
      'is_online': instance.isOnline,
      'distance': instance.distance,
    };
