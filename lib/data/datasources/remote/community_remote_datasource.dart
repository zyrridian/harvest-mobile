import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/community_post_model.dart';
import '../../models/post_comment_model.dart';
import '../../models/paginated_response_model.dart';

abstract class CommunityRemoteDataSource {
  Future<PaginatedResponseModel<CommunityPostModel>> getFarmerPosts(String farmerId, {int? limit, int? page});
  Future<List<PostCommentModel>> getPostComments(String postId);
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final Dio dio;

  CommunityRemoteDataSourceImpl(this.dio);

  @override
  Future<PaginatedResponseModel<CommunityPostModel>> getFarmerPosts(String farmerId, {int? limit, int? page}) async {
    try {
      final queryParams = <String, dynamic>{
        'farmer_id': farmerId,
      };
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;

      final response = await dio.get(
        AppConstants.farmerCommunityPostsEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return PaginatedResponseModel.fromJson(
          response.data,
          (json) => CommunityPostModel.fromJson(json),
        );
      } else {
        throw ServerException(
          'Failed to fetch farmer posts',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<PostCommentModel>> getPostComments(String postId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Mock data - post comments
    final mockComments = _getMockComments(postId);

    return mockComments.map((json) => PostCommentModel.fromJson(json)).toList();
  }

  List<Map<String, dynamic>> _getMockComments(String postId) {
    return [
      {
        'id': 'comment_001',
        'post_id': postId,
        'user_id': 'user_001',
        'user_name': 'Sarah Johnson',
        'user_avatar': null,
        'content': 'This looks amazing! Can\'t wait to visit this weekend 🌿',
        'created_at':
            DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
        'like_count': 5,
        'is_liked': false,
      },
      {
        'id': 'comment_002',
        'post_id': postId,
        'user_id': 'user_002',
        'user_name': 'Ahmad Fauzi',
        'user_avatar': null,
        'content':
            'Do you deliver to Jakarta? I\'d love to order some tomatoes!',
        'created_at':
            DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
        'like_count': 2,
        'is_liked': false,
      },
    ];
  }

  ServerException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Server error occurred';
        throw ServerException(message, statusCode: statusCode);
      case DioExceptionType.cancel:
        throw ServerException('Request cancelled');
      case DioExceptionType.unknown:
        throw NetworkException('No internet connection');
      default:
        throw ServerException('An unexpected error occurred');
    }
  }
}
