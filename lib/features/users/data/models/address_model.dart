import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/address.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  @JsonKey(name: 'address_id')
  final String addressId;

  final String label;

  @JsonKey(name: 'recipient_name')
  final String recipientName;

  final String phone;

  @JsonKey(name: 'full_address')
  final String fullAddress;

  final String province;

  @JsonKey(name: 'province_id')
  final int provinceId;

  final String city;

  @JsonKey(name: 'city_id')
  final int cityId;

  final String district;

  @JsonKey(name: 'district_id')
  final int districtId;

  final String? subdistrict;

  @JsonKey(name: 'postal_code')
  final String postalCode;

  final double latitude;
  final double longitude;
  final String? notes;

  @JsonKey(name: 'is_primary')
  final bool isPrimary;

  @JsonKey(name: 'is_verified')
  final bool isVerified;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  AddressModel({
    required this.addressId,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.fullAddress,
    required this.province,
    required this.provinceId,
    required this.city,
    required this.cityId,
    required this.district,
    required this.districtId,
    this.subdistrict,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    this.notes,
    required this.isPrimary,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  Address toEntity() {
    return Address(
      addressId: addressId,
      label: label,
      recipientName: recipientName,
      phone: phone,
      fullAddress: fullAddress,
      province: province,
      provinceId: provinceId,
      city: city,
      cityId: cityId,
      district: district,
      districtId: districtId,
      subdistrict: subdistrict,
      postalCode: postalCode,
      latitude: latitude,
      longitude: longitude,
      notes: notes,
      isPrimary: isPrimary,
      isVerified: isVerified,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  factory AddressModel.fromEntity(Address entity) {
    return AddressModel(
      addressId: entity.addressId,
      label: entity.label,
      recipientName: entity.recipientName,
      phone: entity.phone,
      fullAddress: entity.fullAddress,
      province: entity.province,
      provinceId: entity.provinceId,
      city: entity.city,
      cityId: entity.cityId,
      district: entity.district,
      districtId: entity.districtId,
      subdistrict: entity.subdistrict,
      postalCode: entity.postalCode,
      latitude: entity.latitude,
      longitude: entity.longitude,
      notes: entity.notes,
      isPrimary: entity.isPrimary,
      isVerified: entity.isVerified,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}

@JsonSerializable()
class ProvinceModel {
  @JsonKey(name: 'province_id')
  final int provinceId;

  final String name;

  ProvinceModel({
    required this.provinceId,
    required this.name,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) =>
      _$ProvinceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProvinceModelToJson(this);

  Province toEntity() {
    return Province(
      provinceId: provinceId,
      name: name,
    );
  }
}

@JsonSerializable()
class CityModel {
  @JsonKey(name: 'city_id')
  final int cityId;

  @JsonKey(name: 'province_id')
  final int provinceId;

  final String name;
  final String type;

  CityModel({
    required this.cityId,
    required this.provinceId,
    required this.name,
    required this.type,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);

  City toEntity() {
    return City(
      cityId: cityId,
      provinceId: provinceId,
      name: name,
      type: type,
    );
  }
}

@JsonSerializable()
class DistrictModel {
  @JsonKey(name: 'district_id')
  final int districtId;

  @JsonKey(name: 'city_id')
  final int cityId;

  final String name;

  DistrictModel({
    required this.districtId,
    required this.cityId,
    required this.name,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) =>
      _$DistrictModelFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictModelToJson(this);

  District toEntity() {
    return District(
      districtId: districtId,
      cityId: cityId,
      name: name,
    );
  }
}

@JsonSerializable()
class GeocodeResultModel {
  @JsonKey(name: 'formatted_address')
  final String formattedAddress;

  final String province;

  @JsonKey(name: 'province_id')
  final int provinceId;

  final String city;

  @JsonKey(name: 'city_id')
  final int cityId;

  final String district;

  @JsonKey(name: 'district_id')
  final int districtId;

  final String? subdistrict;

  @JsonKey(name: 'postal_code')
  final String postalCode;

  final double latitude;
  final double longitude;

  GeocodeResultModel({
    required this.formattedAddress,
    required this.province,
    required this.provinceId,
    required this.city,
    required this.cityId,
    required this.district,
    required this.districtId,
    this.subdistrict,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
  });

  factory GeocodeResultModel.fromJson(Map<String, dynamic> json) =>
      _$GeocodeResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeocodeResultModelToJson(this);

  GeocodeResult toEntity() {
    return GeocodeResult(
      formattedAddress: formattedAddress,
      province: province,
      provinceId: provinceId,
      city: city,
      cityId: cityId,
      district: district,
      districtId: districtId,
      subdistrict: subdistrict,
      postalCode: postalCode,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

@JsonSerializable()
class ReverseGeocodeResultModel {
  @JsonKey(name: 'formatted_address')
  final String formattedAddress;

  final double latitude;
  final double longitude;
  final String province;
  final String city;
  final String district;
  final double confidence;

  ReverseGeocodeResultModel({
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    required this.province,
    required this.city,
    required this.district,
    required this.confidence,
  });

  factory ReverseGeocodeResultModel.fromJson(Map<String, dynamic> json) =>
      _$ReverseGeocodeResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReverseGeocodeResultModelToJson(this);

  ReverseGeocodeResult toEntity() {
    return ReverseGeocodeResult(
      formattedAddress: formattedAddress,
      latitude: latitude,
      longitude: longitude,
      province: province,
      city: city,
      district: district,
      confidence: confidence,
    );
  }
}
