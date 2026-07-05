import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../data/models/user_profile_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? avatarUrl,
  });
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final Dio dio;

  UserProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<UserProfileModel> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (bio != null) data['bio'] = bio;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;

      final response = await dio.put('/users/profile', data: data);

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data['data']);
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
