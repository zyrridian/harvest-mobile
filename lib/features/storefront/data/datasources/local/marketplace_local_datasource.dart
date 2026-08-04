import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/storefront/data/models/marketplace_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MarketplaceLocalDataSource {
  Future<void> saveMarketplaceData(MarketplaceModel marketplace);
  Future<MarketplaceModel?> getMarketplaceData();
}

class MarketplaceLocalDataSourceImpl implements MarketplaceLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  MarketplaceLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<MarketplaceModel?> getMarketplaceData() async {
    try {
      final marketplaceJson =
          sharedPreferences.getString(AppConstants.marketplaceDataKey);
      if (marketplaceJson != null) {
        return MarketplaceModel.fromJson(jsonDecode(marketplaceJson));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get marketplace data: $e');
    }
  }

  @override
  Future<void> saveMarketplaceData(MarketplaceModel marketplace) async {
    try {
      final marketplaceJson = jsonEncode(marketplace.toJson());
      await sharedPreferences.setString(
          AppConstants.marketplaceDataKey, marketplaceJson);
    } catch (e) {
      throw CacheException('Failed to save marketplace data: $e');
    }
  }
}
