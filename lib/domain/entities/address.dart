import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String addressId;
  final String label;
  final String recipientName;
  final String phone;
  final String fullAddress;
  final String province;
  final int provinceId;
  final String city;
  final int cityId;
  final String district;
  final int districtId;
  final String? subdistrict;
  final String postalCode;
  final double latitude;
  final double longitude;
  final String? notes;
  final bool isPrimary;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Address({
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

  @override
  List<Object?> get props => [
        addressId,
        label,
        recipientName,
        phone,
        fullAddress,
        province,
        provinceId,
        city,
        cityId,
        district,
        districtId,
        subdistrict,
        postalCode,
        latitude,
        longitude,
        notes,
        isPrimary,
        isVerified,
        createdAt,
        updatedAt,
      ];
}

class Province extends Equatable {
  final int provinceId;
  final String name;

  const Province({
    required this.provinceId,
    required this.name,
  });

  @override
  List<Object?> get props => [provinceId, name];
}

class City extends Equatable {
  final int cityId;
  final int provinceId;
  final String name;
  final String type; // Kota, Kabupaten

  const City({
    required this.cityId,
    required this.provinceId,
    required this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [cityId, provinceId, name, type];
}

class District extends Equatable {
  final int districtId;
  final int cityId;
  final String name;

  const District({
    required this.districtId,
    required this.cityId,
    required this.name,
  });

  @override
  List<Object?> get props => [districtId, cityId, name];
}

class GeocodeResult extends Equatable {
  final String formattedAddress;
  final String province;
  final int provinceId;
  final String city;
  final int cityId;
  final String district;
  final int districtId;
  final String? subdistrict;
  final String postalCode;
  final double latitude;
  final double longitude;

  const GeocodeResult({
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

  @override
  List<Object?> get props => [
        formattedAddress,
        province,
        provinceId,
        city,
        cityId,
        district,
        districtId,
        subdistrict,
        postalCode,
        latitude,
        longitude,
      ];
}

class ReverseGeocodeResult extends Equatable {
  final String formattedAddress;
  final double latitude;
  final double longitude;
  final String province;
  final String city;
  final String district;
  final double confidence;

  const ReverseGeocodeResult({
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    required this.province,
    required this.city,
    required this.district,
    required this.confidence,
  });

  @override
  List<Object?> get props => [
        formattedAddress,
        latitude,
        longitude,
        province,
        city,
        district,
        confidence,
      ];
}
