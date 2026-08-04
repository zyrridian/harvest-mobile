import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/storefront/data/models/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeLocalDataSource {
  Future<void> saveHomeData(HomeModel home);
  Future<HomeModel?> getHomeData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  HomeLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<HomeModel?> getHomeData() async {
    try {
      final homeJson = sharedPreferences.getString(AppConstants.homeDataKey);
      if (homeJson != null) {
        return HomeModel.fromJson(jsonDecode(homeJson));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get home data: $e');
    }
  }

  @override
  Future<void> saveHomeData(HomeModel home) async {
    try {
      final homeJson = jsonEncode(home.toJson());
      await sharedPreferences.setString(AppConstants.homeDataKey, homeJson);
    } catch (e) {
      throw CacheException('Failed to save home data: $e');
    }
  }
}
