import 'dart:convert';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/users/data/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AddressLocalDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<void> cacheAddresses(List<AddressModel> addresses);
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  final SharedPreferences sharedPreferences;

  AddressLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final jsonString =
          sharedPreferences.getString(AppConstants.addressesDataKey);
      if (jsonString != null) {
        final List<dynamic> jsonMap = json.decode(jsonString);
        return jsonMap.map((json) => AddressModel.fromJson(json)).toList();
      } else {
        throw CacheException("No addresses found");
      }
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheAddresses(List<AddressModel> addresses) async {
    try {
      final List<Map<String, dynamic>> jsonList =
          addresses.map((address) => address.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(
          AppConstants.addressesDataKey, jsonString);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
