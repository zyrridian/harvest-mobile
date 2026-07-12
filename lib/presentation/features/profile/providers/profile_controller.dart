import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/domain/entities/security_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../features/users/data/datasources/local/user_profile_local_datasource.dart';
import '../../../../features/users/data/datasources/local/security_settings_local_datasource.dart';
import '../../../../features/users/data/datasources/remote/user_profile_remote_datasource.dart';
import '../../../../data/repositories/user_profile_repository.dart';
import '../../../../data/repositories/security_settings_repository.dart';
import 'profile_state.dart';

part 'profile_controller.g.dart';

// ========== DEPENDENCY PROVIDERS ==========
final userProfileLocalDataSourceProvider = Provider<UserProfileLocalDataSource>((ref) {
  return UserProfileLocalDataSource();
});

final securitySettingsLocalDataSourceProvider = Provider<SecuritySettingsLocalDataSource>((ref) {
  return SecuritySettingsLocalDataSource();
});

final userProfileRemoteDataSourceProvider = Provider<UserProfileRemoteDataSource>((ref) {
  return UserProfileRemoteDataSourceImpl(ref.watch(dioProvider));
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final localDataSource = ref.read(userProfileLocalDataSourceProvider);
  final remoteDataSource = ref.watch(userProfileRemoteDataSourceProvider);
  return UserProfileRepository(localDataSource, remoteDataSource);
});

final securitySettingsRepositoryProvider = Provider<SecuritySettingsRepository>((ref) {
  final localDataSource = ref.read(securitySettingsLocalDataSourceProvider);
  return SecuritySettingsRepository(localDataSource);
});

final securitySettingsProvider = FutureProvider<SecuritySettings>((ref) async {
  final repository = ref.read(securitySettingsRepositoryProvider);
  return await repository.getSecuritySettings();
});

// ========== LANGUAGE PROVIDERS ==========
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

// ========== CONTROLLER ==========
@riverpod
class ProfileController extends _$ProfileController {
  @override
  ProfileState build() {
    _fetchProfileData();
    return const ProfileState.loading();
  }

  Future<void> _fetchProfileData() async {
    state = const ProfileState.loading();
    try {
      final storage = ref.read(secureStorageProvider);
      final token = await storage.read(key: AppConstants.authTokenKey);
      
      if (token == null) {
        state = const ProfileState.initial();
        return;
      }

      final repository = ref.read(userProfileRepositoryProvider);
      final profile = await repository.getUserProfile();
      state = ProfileState.data(profile);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    await _fetchProfileData();
  }

  Future<void> updateUserProfile({
    required String name,
    String? phoneNumber,
    String? bio,
  }) async {
    final repository = ref.read(userProfileRepositoryProvider);
    await repository.updateUserProfile(
      name: name,
      phoneNumber: phoneNumber,
      bio: bio,
    );
    await _fetchProfileData();
  }

  Future<void> updateProfileImage(String imageUrl) async {
    final repository = ref.read(userProfileRepositoryProvider);
    await repository.updateProfileImage(imageUrl);
    await _fetchProfileData();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final repository = ref.read(userProfileRepositoryProvider);
    await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> updateTwoFactor(bool enabled) async {
    final repository = ref.read(securitySettingsRepositoryProvider);
    await repository.updateTwoFactor(enabled);
    ref.invalidate(securitySettingsProvider);
  }

  Future<void> updateBiometric(bool enabled) async {
    final repository = ref.read(securitySettingsRepositoryProvider);
    await repository.updateBiometric(enabled);
    ref.invalidate(securitySettingsProvider);
  }

  Future<void> terminateSession(String sessionName) async {
    final repository = ref.read(securitySettingsRepositoryProvider);
    await repository.terminateSession(sessionName);
    ref.invalidate(securitySettingsProvider);
  }
}
