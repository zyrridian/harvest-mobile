import '../../models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress(Map<String, dynamic> addressData);
  Future<AddressModel> updateAddress(
    String addressId,
    Map<String, dynamic> addressData,
  );
  Future<void> deleteAddress(String addressId);
  Future<AddressModel> setPrimaryAddress(String addressId);
  Future<List<ProvinceModel>> getProvinces();
  Future<List<CityModel>> getCities(int provinceId);
  Future<List<DistrictModel>> getDistricts(int cityId);
  Future<GeocodeResultModel> geocode(double latitude, double longitude);
  Future<List<ReverseGeocodeResultModel>> reverseGeocode(String address);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  @override
  Future<List<AddressModel>> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "addresses": [
          {
            "address_id": "addr_1234567890",
            "label": "Home",
            "recipient_name": "Ahmad Zulfikar",
            "phone": "+6285678901234",
            "full_address": "Jl. Sudirman No. 123, RT 01/RW 05",
            "province": "West Java",
            "province_id": 32,
            "city": "Bandung",
            "city_id": 3273,
            "district": "Coblong",
            "district_id": 327305,
            "subdistrict": "Cipaganti",
            "postal_code": "40132",
            "latitude": -6.914744,
            "longitude": 107.609810,
            "notes": "Rumah cat hijau, pagar hitam",
            "is_primary": true,
            "is_verified": true,
            "created_at": "2025-09-01T10:00:00Z",
            "updated_at": "2025-09-01T10:00:00Z"
          },
          {
            "address_id": "addr_9876543210",
            "label": "Office",
            "recipient_name": "Ahmad Zulfikar",
            "phone": "+6285678901234",
            "full_address": "Jl. Asia Afrika No. 8",
            "province": "West Java",
            "province_id": 32,
            "city": "Bandung",
            "city_id": 3273,
            "district": "Sumur Bandung",
            "district_id": 327301,
            "subdistrict": "Braga",
            "postal_code": "40111",
            "latitude": -6.921586,
            "longitude": 107.607376,
            "notes": "Gedung lantai 5, sebelah lift",
            "is_primary": false,
            "is_verified": false,
            "created_at": "2025-09-15T14:00:00Z",
            "updated_at": "2025-09-15T14:00:00Z"
          }
        ],
        "total_count": 2
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    final addressesList = data['addresses'] as List;
    return addressesList
        .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AddressModel> addAddress(Map<String, dynamic> addressData) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "message": "Address added successfully",
      "data": {
        "address_id": "addr_${DateTime.now().millisecondsSinceEpoch}",
        "label": addressData['label'] ?? "Home",
        "recipient_name": addressData['recipient_name'] ?? "User",
        "phone": addressData['phone'] ?? "+628123456789",
        "full_address": addressData['full_address'] ?? "",
        "province": "West Java",
        "province_id": addressData['province_id'] ?? 32,
        "city": "Bandung",
        "city_id": addressData['city_id'] ?? 3273,
        "district": "Coblong",
        "district_id": addressData['district_id'] ?? 327305,
        "postal_code": addressData['postal_code'] ?? "40132",
        "latitude": addressData['latitude'] ?? -6.914744,
        "longitude": addressData['longitude'] ?? 107.609810,
        "notes": addressData['notes'],
        "is_primary": addressData['is_primary'] ?? false,
        "is_verified": false,
        "created_at": DateTime.now().toIso8601String(),
        "updated_at": DateTime.now().toIso8601String()
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return AddressModel.fromJson(data);
  }

  @override
  Future<AddressModel> updateAddress(
    String addressId,
    Map<String, dynamic> addressData,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "message": "Address updated successfully",
      "data": {
        "address_id": addressId,
        "label": addressData['label'] ?? "Home",
        "recipient_name": addressData['recipient_name'] ?? "User",
        "phone": addressData['phone'] ?? "+628123456789",
        "full_address": addressData['full_address'] ?? "",
        "province": "West Java",
        "province_id": 32,
        "city": "Bandung",
        "city_id": 3273,
        "district": "Coblong",
        "district_id": 327305,
        "postal_code": "40132",
        "latitude": -6.914744,
        "longitude": 107.609810,
        "notes": addressData['notes'],
        "is_primary": false,
        "is_verified": true,
        "created_at": "2025-09-01T10:00:00Z",
        "updated_at": DateTime.now().toIso8601String()
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return AddressModel.fromJson(data);
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Success - no return value
  }

  @override
  Future<AddressModel> setPrimaryAddress(String addressId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "message": "Primary address updated",
      "data": {
        "address_id": addressId,
        "label": "Home",
        "recipient_name": "Ahmad Zulfikar",
        "phone": "+6285678901234",
        "full_address": "Jl. Sudirman No. 123",
        "province": "West Java",
        "province_id": 32,
        "city": "Bandung",
        "city_id": 3273,
        "district": "Coblong",
        "district_id": 327305,
        "postal_code": "40132",
        "latitude": -6.914744,
        "longitude": 107.609810,
        "is_primary": true,
        "is_verified": true,
        "created_at": "2025-09-01T10:00:00Z",
        "updated_at": DateTime.now().toIso8601String()
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return AddressModel.fromJson(data);
  }

  @override
  Future<List<ProvinceModel>> getProvinces() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "provinces": [
          {"province_id": 11, "name": "Aceh"},
          {"province_id": 31, "name": "DKI Jakarta"},
          {"province_id": 32, "name": "West Java"},
          {"province_id": 33, "name": "Central Java"},
          {"province_id": 35, "name": "East Java"},
          {"province_id": 51, "name": "Bali"},
        ],
        "total_count": 34
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    final provincesList = data['provinces'] as List;
    return provincesList
        .map((json) => ProvinceModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CityModel>> getCities(int provinceId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "cities": [
          {
            "city_id": 3273,
            "province_id": provinceId,
            "name": "Bandung",
            "type": "Kota"
          },
          {
            "city_id": 3204,
            "province_id": provinceId,
            "name": "Bandung",
            "type": "Kabupaten"
          },
          {
            "city_id": 3277,
            "province_id": provinceId,
            "name": "Cimahi",
            "type": "Kota"
          },
        ],
        "total_count": 27
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    final citiesList = data['cities'] as List;
    return citiesList
        .map((json) => CityModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<DistrictModel>> getDistricts(int cityId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "districts": [
          {"district_id": 327301, "city_id": cityId, "name": "Sumur Bandung"},
          {"district_id": 327305, "city_id": cityId, "name": "Coblong"},
          {"district_id": 327310, "city_id": cityId, "name": "Cidadap"},
          {"district_id": 327320, "city_id": cityId, "name": "Cicendo"},
        ],
        "total_count": 30
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    final districtsList = data['districts'] as List;
    return districtsList
        .map((json) => DistrictModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<GeocodeResultModel> geocode(
    double latitude,
    double longitude,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "formatted_address": "Jl. Cipaganti, Coblong, Bandung, West Java 40132",
        "province": "West Java",
        "province_id": 32,
        "city": "Bandung",
        "city_id": 3273,
        "district": "Coblong",
        "district_id": 327305,
        "subdistrict": "Cipaganti",
        "postal_code": "40132",
        "latitude": latitude,
        "longitude": longitude
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return GeocodeResultModel.fromJson(data);
  }

  @override
  Future<List<ReverseGeocodeResultModel>> reverseGeocode(
    String address,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "results": [
          {
            "formatted_address":
                "Jl. Asia Afrika No. 8, Braga, Sumur Bandung, Bandung, West Java",
            "latitude": -6.921586,
            "longitude": 107.607376,
            "province": "West Java",
            "city": "Bandung",
            "district": "Sumur Bandung",
            "confidence": 0.95
          }
        ]
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    final resultsList = data['results'] as List;
    return resultsList
        .map((json) =>
            ReverseGeocodeResultModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
