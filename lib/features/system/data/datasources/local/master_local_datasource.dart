import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/system/data/models/master_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MasterLocalDataSource {
  Future<void> saveProvinces(List<ProvinceModel> provinces);
  Future<List<ProvinceModel>?> getProvinces();
  
  Future<void> saveCities(int provinceId, List<CityModel> cities);
  Future<List<CityModel>?> getCities(int provinceId);
  
  Future<void> saveDistricts(int cityId, List<DistrictModel> districts);
  Future<List<DistrictModel>?> getDistricts(int cityId);
}

class MasterLocalDataSourceImpl implements MasterLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  MasterLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<List<ProvinceModel>?> getProvinces() async {
    try {
      final jsonStr = sharedPreferences.getString(AppConstants.masterProvincesKey);
      if (jsonStr != null) {
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        return jsonList.map((e) => ProvinceModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get provinces data: $e');
    }
  }

  @override
  Future<void> saveProvinces(List<ProvinceModel> provinces) async {
    try {
      final jsonList = provinces.map((e) => e.toJson()).toList();
      await sharedPreferences.setString(AppConstants.masterProvincesKey, jsonEncode(jsonList));
    } catch (e) {
      throw CacheException('Failed to save provinces data: $e');
    }
  }

  @override
  Future<List<CityModel>?> getCities(int provinceId) async {
    try {
      final jsonStr = sharedPreferences.getString('${AppConstants.masterCitiesKey}_$provinceId');
      if (jsonStr != null) {
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        return jsonList.map((e) => CityModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cities data: $e');
    }
  }

  @override
  Future<void> saveCities(int provinceId, List<CityModel> cities) async {
    try {
      final jsonList = cities.map((e) => e.toJson()).toList();
      await sharedPreferences.setString('${AppConstants.masterCitiesKey}_$provinceId', jsonEncode(jsonList));
    } catch (e) {
      throw CacheException('Failed to save cities data: $e');
    }
  }

  @override
  Future<List<DistrictModel>?> getDistricts(int cityId) async {
    try {
      final jsonStr = sharedPreferences.getString('${AppConstants.masterDistrictsKey}_$cityId');
      if (jsonStr != null) {
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        return jsonList.map((e) => DistrictModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get districts data: $e');
    }
  }

  @override
  Future<void> saveDistricts(int cityId, List<DistrictModel> districts) async {
    try {
      final jsonList = districts.map((e) => e.toJson()).toList();
      await sharedPreferences.setString('${AppConstants.masterDistrictsKey}_$cityId', jsonEncode(jsonList));
    } catch (e) {
      throw CacheException('Failed to save districts data: $e');
    }
  }
}
