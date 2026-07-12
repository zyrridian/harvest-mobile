import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/preorder/preorder_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PreorderLocalDataSource {
  Future<void> savePreorderData(PreOrderModel data);
  Future<PreOrderModel?> getPreorderData();
}

class PreorderLocalDataSourceImpl implements PreorderLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  PreorderLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<PreOrderModel?> getPreorderData() async {
    try {
      final dataJson = sharedPreferences.getString(AppConstants.preorderDataKey);
      if (dataJson != null) {
        return PreOrderModel.fromJson(jsonDecode(dataJson));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get preorder data: $e');
    }
  }

  @override
  Future<void> savePreorderData(PreOrderModel data) async {
    try {
      final dataJson = jsonEncode(data.toJson());
      await sharedPreferences.setString(AppConstants.preorderDataKey, dataJson);
    } catch (e) {
      throw CacheException('Failed to save preorder data: $e');
    }
  }
}
