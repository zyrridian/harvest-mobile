import '../models/user_profile_model.dart';

class UserProfileLocalDataSource {
  // Simulated in-memory user profile
  UserProfileModel _currentProfile = UserProfileModel(
    id: 'user_001',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '+1 (555) 123-4567',
    profileImageUrl: 'https://i.pravatar.cc/300',
    bio: 'Passionate about fresh, local produce and sustainable farming.',
    createdAt: DateTime(2024, 1, 15).toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
  );

  Future<UserProfileModel> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentProfile;
  }

  Future<UserProfileModel> updateUserProfile({
    required String name,
    String? phone,
    String? bio,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    _currentProfile = UserProfileModel(
      id: _currentProfile.id,
      name: name,
      email: _currentProfile.email,
      phone: phone,
      profileImageUrl: _currentProfile.profileImageUrl,
      bio: bio,
      createdAt: _currentProfile.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    return _currentProfile;
  }

  Future<UserProfileModel> updateProfileImage(String imageUrl) async {
    await Future.delayed(const Duration(milliseconds: 600));

    _currentProfile = UserProfileModel(
      id: _currentProfile.id,
      name: _currentProfile.name,
      email: _currentProfile.email,
      phone: _currentProfile.phone,
      profileImageUrl: imageUrl,
      bio: _currentProfile.bio,
      createdAt: _currentProfile.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    return _currentProfile;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Simulate password change
    // In real app, this would validate current password and update it
  }

  Future<void> changeEmail({
    required String newEmail,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _currentProfile = UserProfileModel(
      id: _currentProfile.id,
      name: _currentProfile.name,
      email: newEmail,
      phone: _currentProfile.phone,
      profileImageUrl: _currentProfile.profileImageUrl,
      bio: _currentProfile.bio,
      createdAt: _currentProfile.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}
