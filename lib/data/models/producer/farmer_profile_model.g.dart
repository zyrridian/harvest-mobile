// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerProfileResponseModel _$FarmerProfileResponseModelFromJson(
        Map<String, dynamic> json) =>
    FarmerProfileResponseModel(
      status: json['status'] as String,
      data: FarmerProfileModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FarmerProfileResponseModelToJson(
        FarmerProfileResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

FarmerProfileModel _$FarmerProfileModelFromJson(Map<String, dynamic> json) =>
    FarmerProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      profileImage: json['profile_image'] as String?,
      coverImage: json['cover_image'] as String?,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phoneNumber: json['phone_number'] as String?,
      specialties: (json['specialties'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isVerified: json['is_verified'] as bool,
    );

Map<String, dynamic> _$FarmerProfileModelToJson(FarmerProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'profile_image': instance.profileImage,
      'cover_image': instance.coverImage,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone_number': instance.phoneNumber,
      'specialties': instance.specialties,
      'is_verified': instance.isVerified,
    };
