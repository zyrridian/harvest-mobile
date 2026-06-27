import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/db_provider.dart';
import '../../features/auth/data/models/user_model.dart';

/// Keys for storage
class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tokenExpiry = 'token_expiry';
  static const String userData = 'user_data';
  static const String isFirstLaunch = 'is_first_launch';
  static const String isLoggedIn = 'is_logged_in';
}

/// Service for secure storage operations (tokens, sensitive data)
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  // Token operations
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: StorageKeys.accessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: StorageKeys.accessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: StorageKeys.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: StorageKeys.refreshToken);
  }

  Future<void> saveTokenExpiry(DateTime expiry) async {
    await _storage.write(
      key: StorageKeys.tokenExpiry,
      value: expiry.toIso8601String(),
    );
  }

  Future<DateTime?> getTokenExpiry() async {
    final expiryStr = await _storage.read(key: StorageKeys.tokenExpiry);
    if (expiryStr != null) {
      return DateTime.parse(expiryStr);
    }
    return null;
  }

  Future<bool> isTokenExpired() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true;
    // Consider token expired 1 minute before actual expiry for safety
    return DateTime.now().isAfter(expiry.subtract(const Duration(minutes: 1)));
  }

  // User data operations
  Future<void> saveUserData(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: StorageKeys.userData, value: userJson);
  }

  Future<UserModel?> getUserData() async {
    final userJson = await _storage.read(key: StorageKeys.userData);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Auth state
  Future<void> setLoggedIn(bool value) async {
    await _storage.write(key: StorageKeys.isLoggedIn, value: value.toString());
  }

  Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: StorageKeys.isLoggedIn);
    return value == 'true';
  }

  // Clear all auth data
  Future<void> clearAuthData() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.tokenExpiry);
    await _storage.delete(key: StorageKeys.userData);
    await _storage.delete(key: StorageKeys.isLoggedIn);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

/// Service for regular preferences (non-sensitive data)
class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  // First launch check for onboarding
  bool isFirstLaunch() {
    return _prefs.getBool(StorageKeys.isFirstLaunch) ?? true;
  }

  Future<void> setFirstLaunchComplete() async {
    await _prefs.setBool(StorageKeys.isFirstLaunch, false);
  }

  // Generic methods
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }
}

/// Provider for SecureStorageService
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  return SecureStorageService(storage);
});

/// Provider for PreferencesService (uses sharedPreferencesProvider from db_provider.dart)
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesService(prefs);
});
