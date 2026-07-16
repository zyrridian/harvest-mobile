import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/user_profile_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateProfile({
    String? name,
    String? phoneNumber,
    String? bio,
    String? avatarUrl,
  });
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final Dio dio;

  UserProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await dio.get('/users/profile');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        // The API returns { "data": { "user": {...}, "profile": null } }
        return UserProfileModel.fromJson(response.data['data']['user']);
      } else {
        throw ServerException(
          'Failed to get user profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data['message'] ?? 'Server error occurred';
      throw ServerException(message, statusCode: statusCode);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<UserProfileModel> updateProfile({
    String? name,
    String? phoneNumber,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (phoneNumber != null) data['phone'] = phoneNumber;
      if (bio != null) data['bio'] = bio;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;

      final response = await dio.put('/users/profile', data: data);

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return UserProfileModel.fromJson(response.data['data']['user']);
      } else {
        throw ServerException(
          'Failed to update user profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data['message'] ?? 'Server error occurred';
      throw ServerException(message, statusCode: statusCode);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}
