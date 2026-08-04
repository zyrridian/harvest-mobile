// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sourcing_offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SourcingOfferFarmerModelImpl _$$SourcingOfferFarmerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SourcingOfferFarmerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profile_image'] as String?,
      rating: (json['rating'] as num).toDouble(),
      isVerified: json['is_verified'] as bool,
    );

Map<String, dynamic> _$$SourcingOfferFarmerModelImplToJson(
        _$SourcingOfferFarmerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_image': instance.profileImage,
      'rating': instance.rating,
      'is_verified': instance.isVerified,
    };

_$SourcingOfferModelImpl _$$SourcingOfferModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SourcingOfferModelImpl(
      id: json['id'] as String,
      price: (json['price'] as num).toDouble(),
      notes: json['notes'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      farmer: json['farmer'] == null
          ? null
          : SourcingOfferFarmerModel.fromJson(
              json['farmer'] as Map<String, dynamic>),
      request: json['request'] == null
          ? null
          : SourcingRequestModel.fromJson(
              json['request'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SourcingOfferModelImplToJson(
        _$SourcingOfferModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'notes': instance.notes,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'farmer': instance.farmer,
      'request': instance.request,
    };
