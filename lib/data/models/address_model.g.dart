// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      addressId: json['address_id'] as String,
      label: json['label'] as String,
      recipientName: json['recipient_name'] as String,
      phone: json['phone'] as String,
      fullAddress: json['full_address'] as String,
      province: json['province'] as String,
      provinceId: (json['province_id'] as num).toInt(),
      city: json['city'] as String,
      cityId: (json['city_id'] as num).toInt(),
      district: json['district'] as String,
      districtId: (json['district_id'] as num).toInt(),
      subdistrict: json['subdistrict'] as String?,
      postalCode: json['postal_code'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      notes: json['notes'] as String?,
      isPrimary: json['is_primary'] as bool,
      isVerified: json['is_verified'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'address_id': instance.addressId,
      'label': instance.label,
      'recipient_name': instance.recipientName,
      'phone': instance.phone,
      'full_address': instance.fullAddress,
      'province': instance.province,
      'province_id': instance.provinceId,
      'city': instance.city,
      'city_id': instance.cityId,
      'district': instance.district,
      'district_id': instance.districtId,
      'subdistrict': instance.subdistrict,
      'postal_code': instance.postalCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
      'is_primary': instance.isPrimary,
      'is_verified': instance.isVerified,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ProvinceModel _$ProvinceModelFromJson(Map<String, dynamic> json) =>
    ProvinceModel(
      provinceId: (json['province_id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProvinceModelToJson(ProvinceModel instance) =>
    <String, dynamic>{
      'province_id': instance.provinceId,
      'name': instance.name,
    };

CityModel _$CityModelFromJson(Map<String, dynamic> json) => CityModel(
      cityId: (json['city_id'] as num).toInt(),
      provinceId: (json['province_id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$CityModelToJson(CityModel instance) => <String, dynamic>{
      'city_id': instance.cityId,
      'province_id': instance.provinceId,
      'name': instance.name,
      'type': instance.type,
    };

DistrictModel _$DistrictModelFromJson(Map<String, dynamic> json) =>
    DistrictModel(
      districtId: (json['district_id'] as num).toInt(),
      cityId: (json['city_id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$DistrictModelToJson(DistrictModel instance) =>
    <String, dynamic>{
      'district_id': instance.districtId,
      'city_id': instance.cityId,
      'name': instance.name,
    };

GeocodeResultModel _$GeocodeResultModelFromJson(Map<String, dynamic> json) =>
    GeocodeResultModel(
      formattedAddress: json['formatted_address'] as String,
      province: json['province'] as String,
      provinceId: (json['province_id'] as num).toInt(),
      city: json['city'] as String,
      cityId: (json['city_id'] as num).toInt(),
      district: json['district'] as String,
      districtId: (json['district_id'] as num).toInt(),
      subdistrict: json['subdistrict'] as String?,
      postalCode: json['postal_code'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GeocodeResultModelToJson(GeocodeResultModel instance) =>
    <String, dynamic>{
      'formatted_address': instance.formattedAddress,
      'province': instance.province,
      'province_id': instance.provinceId,
      'city': instance.city,
      'city_id': instance.cityId,
      'district': instance.district,
      'district_id': instance.districtId,
      'subdistrict': instance.subdistrict,
      'postal_code': instance.postalCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

ReverseGeocodeResultModel _$ReverseGeocodeResultModelFromJson(
        Map<String, dynamic> json) =>
    ReverseGeocodeResultModel(
      formattedAddress: json['formatted_address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      province: json['province'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$ReverseGeocodeResultModelToJson(
        ReverseGeocodeResultModel instance) =>
    <String, dynamic>{
      'formatted_address': instance.formattedAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'confidence': instance.confidence,
    };
