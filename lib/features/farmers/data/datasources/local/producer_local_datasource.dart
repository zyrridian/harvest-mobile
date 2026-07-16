import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/farmers/data/models/farmer_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProducerLocalDataSource {
  Future<void> saveFarmerProducts(List<FarmerProductModel> products);
  Future<List<FarmerProductModel>?> getFarmerProducts();
}

class ProducerLocalDataSourceImpl implements ProducerLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  static const String farmerProductsKey = 'farmer_products_data';

  ProducerLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<List<FarmerProductModel>?> getFarmerProducts() async {
    try {
      final jsonString = sharedPreferences.getString(farmerProductsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((e) => FarmerProductModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get farmer products: $e');
    }
  }

  @override
  Future<void> saveFarmerProducts(List<FarmerProductModel> products) async {
    try {
      final jsonList = products.map((e) => e.toJson()).toList();
      await sharedPreferences.setString(farmerProductsKey, jsonEncode(jsonList));
    } catch (e) {
      throw CacheException('Failed to save farmer products: $e');
    }
  }
}
