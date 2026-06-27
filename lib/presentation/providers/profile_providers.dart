import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/users/data/datasources/local/user_profile_local_datasource.dart';
import '../../features/users/data/datasources/local/security_settings_local_datasource.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../data/repositories/security_settings_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/security_settings.dart';

// ========== DATA SOURCES ==========
final userProfileLocalDataSourceProvider =
    Provider<UserProfileLocalDataSource>((ref) {
  return UserProfileLocalDataSource();
});

final securitySettingsLocalDataSourceProvider =
    Provider<SecuritySettingsLocalDataSource>((ref) {
  return SecuritySettingsLocalDataSource();
});

// ========== REPOSITORIES ==========
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final localDataSource = ref.read(userProfileLocalDataSourceProvider);
  return UserProfileRepository(localDataSource);
});

final securitySettingsRepositoryProvider =
    Provider<SecuritySettingsRepository>((ref) {
  final localDataSource = ref.read(securitySettingsLocalDataSourceProvider);
  return SecuritySettingsRepository(localDataSource);
});

// ========== STATE PROVIDERS ==========
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final repository = ref.read(userProfileRepositoryProvider);
  return await repository.getUserProfile();
});

final securitySettingsProvider = FutureProvider<SecuritySettings>((ref) async {
  final repository = ref.read(securitySettingsRepositoryProvider);
  return await repository.getSecuritySettings();
});

// ========== UPDATE PROFILE USE CASE ==========
final updateUserProfileProvider = Provider<
    Future<UserProfile> Function({
      required String name,
      String? phone,
      String? bio,
    })>((ref) {
  return ({
    required String name,
    String? phone,
    String? bio,
  }) async {
    final repository = ref.read(userProfileRepositoryProvider);
    final result = await repository.updateUserProfile(
      name: name,
      phone: phone,
      bio: bio,
    );
    // Refresh the profile provider
    ref.invalidate(userProfileProvider);
    return result;
  };
});

// ========== UPDATE PROFILE IMAGE USE CASE ==========
final updateProfileImageProvider =
    Provider<Future<UserProfile> Function(String imageUrl)>((ref) {
  return (String imageUrl) async {
    final repository = ref.read(userProfileRepositoryProvider);
    final result = await repository.updateProfileImage(imageUrl);
    ref.invalidate(userProfileProvider);
    return result;
  };
});

// ========== CHANGE PASSWORD USE CASE ==========
final changePasswordProvider = Provider<
    Future<void> Function({
      required String currentPassword,
      required String newPassword,
    })>((ref) {
  return ({
    required String currentPassword,
    required String newPassword,
  }) async {
    final repository = ref.read(userProfileRepositoryProvider);
    await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  };
});

// ========== UPDATE TWO FACTOR USE CASE ==========
final updateTwoFactorProvider =
    Provider<Future<SecuritySettings> Function(bool enabled)>((ref) {
  return (bool enabled) async {
    final repository = ref.read(securitySettingsRepositoryProvider);
    final result = await repository.updateTwoFactor(enabled);
    ref.invalidate(securitySettingsProvider);
    return result;
  };
});

// ========== UPDATE BIOMETRIC USE CASE ==========
final updateBiometricProvider =
    Provider<Future<SecuritySettings> Function(bool enabled)>((ref) {
  return (bool enabled) async {
    final repository = ref.read(securitySettingsRepositoryProvider);
    final result = await repository.updateBiometric(enabled);
    ref.invalidate(securitySettingsProvider);
    return result;
  };
});

// ========== TERMINATE SESSION USE CASE ==========
final terminateSessionProvider =
    Provider<Future<void> Function(String sessionName)>((ref) {
  return (String sessionName) async {
    final repository = ref.read(securitySettingsRepositoryProvider);
    await repository.terminateSession(sessionName);
    ref.invalidate(securitySettingsProvider);
  };
});

// ========== LANGUAGE SETTINGS ==========
final languageProvider = StateProvider<String>((ref) => 'English');

final availableLanguagesProvider = Provider<List<Map<String, String>>>((ref) {
  return [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
    {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
    {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
    {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
    {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
  ];
});
