import '../../domain/entities/user_profile.dart';
import '../../features/users/data/datasources/local/user_profile_local_datasource.dart';
import '../../features/users/data/datasources/remote/user_profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class UserProfileRepository {
  final UserProfileLocalDataSource _localDataSource;
  final UserProfileRemoteDataSource _remoteDataSource;

  UserProfileRepository(this._localDataSource, this._remoteDataSource);

  Future<UserProfile> getUserProfile() async {
    final model = await _localDataSource.getUserProfile();
    return _toEntity(model);
  }

  Future<UserProfile> updateUserProfile({
    required String name,
    String? phone,
    String? bio,
  }) async {
    final model = await _remoteDataSource.updateProfile(
      name: name,
      phone: phone,
      bio: bio,
    );
    // Also update local cache if needed
    await _localDataSource.updateUserProfile(name: name, phone: phone, bio: bio);
    return _toEntity(model);
  }

  Future<UserProfile> updateProfileImage(String imageUrl) async {
    final model = await _remoteDataSource.updateProfile(avatarUrl: imageUrl);
    // Also update local cache
    await _localDataSource.updateProfileImage(imageUrl);
    return _toEntity(model);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _localDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> changeEmail({
    required String newEmail,
    required String password,
  }) async {
    await _localDataSource.changeEmail(
      newEmail: newEmail,
      password: password,
    );
  }

  UserProfile _toEntity(UserProfileModel model) {
    return UserProfile(
      id: model.id,
      name: model.name,
      email: model.email,
      phone: model.phone,
      profileImageUrl: model.profileImageUrl,
      bio: model.bio,
      createdAt: DateTime.parse(model.createdAt),
      updatedAt: DateTime.parse(model.updatedAt),
    );
  }
}
