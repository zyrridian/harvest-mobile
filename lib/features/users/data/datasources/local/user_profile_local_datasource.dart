import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_profile_model.dart';

class UserProfileLocalDataSource {
  static const String _cacheKey = 'cached_user_profile';

  Future<UserProfileModel?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_cacheKey);
    if (jsonStr != null) {
      try {
        return UserProfileModel.fromJson(jsonDecode(jsonStr));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> cacheUserProfile(UserProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(profile.toJson()));
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // To be implemented with remote data source
  }

  Future<void> changeEmail({
    required String newEmail,
    required String password,
  }) async {
    // To be implemented with remote data source
  }
}
