import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/community_post_model.dart';
import '../../models/recipe_model.dart';
import '../../../../../core/models/paginated_response_model.dart';
import '../../models/community_comment_model.dart';

abstract class CommunityRemoteDataSource {
  Future<PaginatedResponseModel<CommunityPostModel>> getCommunityPosts({
    required int page,
    required int limit,
    required String filter,
    String? tag,
  });

  Future<List<RecipeModel>> getRecipes();

  Future<void> likePost(String postId);

  Future<void> unlikePost(String postId);

  Future<CommunityPostModel> createPost({
    required String title,
    required String content,
    List<String> images = const [],
    List<String> tags = const [],
  });

  Future<CommunityPostModel> editPost({
    required String postId,
    required String title,
    required String content,
  });

  Future<void> deletePost(String postId);

  Future<PaginatedResponseModel<CommunityCommentModel>> getPostComments({
    required String postId,
    required int page,
    required int limit,
  });

  Future<CommunityCommentModel> createComment({
    required String postId,
    required String content,
    String? parentId,
    String? replyToUserId,
  });

  Future<void> likeComment(String commentId);

  Future<void> unlikeComment(String commentId);

  Future<void> deleteComment(String commentId);
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final Dio dio;

  CommunityRemoteDataSourceImpl(this.dio);

  @override
  Future<PaginatedResponseModel<CommunityPostModel>> getCommunityPosts({
    required int page,
    required int limit,
    required String filter,
    String? tag,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'filter': filter,
      };
      if (tag != null) {
        queryParams['tag'] = tag;
      }

      final response = await dio.get(
        '/community/posts',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return PaginatedResponseModel.fromJson(
          response.data,
          (json) => CommunityPostModel.fromJson(json),
        );
      } else {
        throw ServerException(
          'Failed to fetch community posts',
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
  Future<List<RecipeModel>> getRecipes() async {
    try {
      final response = await dio.get('/recipes');

      if (response.statusCode == 200) {
        final data = response.data['data']['recipes'] as List;
        return data.map((json) => RecipeModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to fetch recipes',
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
  Future<void> likePost(String postId) async {
    try {
      final response = await dio.post('/community/posts/$postId/like');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          'Failed to like post',
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
  Future<void> unlikePost(String postId) async {
    try {
      final response = await dio.delete('/community/posts/$postId/like');
      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to unlike post',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
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

  @override
  Future<CommunityPostModel> createPost({
    required String title,
    required String content,
    List<String> images = const [],
    List<String> tags = const [],
  }) async {
    try {
      final response = await dio.post(
        '/community/posts',
        data: {
          'title': title,
          'content': content,
          'images': images,
          'tags': tags,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CommunityPostModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to create post', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<CommunityPostModel> editPost({
    required String postId,
    required String title,
    required String content,
  }) async {
    try {
      final response = await dio.put(
        '/community/posts/$postId',
        data: {
          'title': title,
          'content': content,
        },
      );
      if (response.statusCode == 200) {
        return CommunityPostModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to edit post', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      final response = await dio.delete('/community/posts/$postId');
      if (response.statusCode != 200) {
        throw ServerException('Failed to delete post', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<PaginatedResponseModel<CommunityCommentModel>> getPostComments({
    required String postId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        '/community/posts/$postId/comments',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        return PaginatedResponseModel.fromJson(
          response.data,
          (json) => CommunityCommentModel.fromJson(json),
        );
      } else {
        throw ServerException('Failed to fetch comments', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<CommunityCommentModel> createComment({
    required String postId,
    required String content,
    String? parentId,
    String? replyToUserId,
  }) async {
    try {
      final data = <String, dynamic>{
        'content': content,
      };
      if (parentId != null) data['parent_id'] = parentId;
      if (replyToUserId != null) data['reply_to_user_id'] = replyToUserId;

      final response = await dio.post(
        '/community/posts/$postId/comments',
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CommunityCommentModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to create comment', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> likeComment(String commentId) async {
    try {
      final response = await dio.post('/community/comments/$commentId/like');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Failed to like comment', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> unlikeComment(String commentId) async {
    try {
      final response = await dio.delete('/community/comments/$commentId/like');
      if (response.statusCode != 200) {
        throw ServerException('Failed to unlike comment', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      final response = await dio.delete('/community/comments/$commentId');
      if (response.statusCode != 200) {
        throw ServerException('Failed to delete comment', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}
