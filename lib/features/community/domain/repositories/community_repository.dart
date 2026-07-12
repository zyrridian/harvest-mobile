import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/community_post.dart';
import '../entities/recipe.dart';
import '../../../../domain/entities/paginated_response.dart';
import '../entities/community_comment.dart';

abstract class CommunityRepository {
  Future<Either<Failure, PaginatedResponse<CommunityPost>>> getCommunityPosts({
    required int page,
    required int limit,
    required String filter,
    String? tag,
  });

  Future<Either<Failure, List<Recipe>>> getRecipes();

  Future<Either<Failure, void>> likePost(String postId);

  Future<Either<Failure, void>> unlikePost(String postId);

  Future<Either<Failure, CommunityPost>> createPost({
    required String title,
    required String content,
    List<String> images = const [],
    List<String> tags = const [],
  });

  Future<Either<Failure, CommunityPost>> editPost({
    required String postId,
    required String title,
    required String content,
  });

  Future<Either<Failure, void>> deletePost(String postId);

  Future<Either<Failure, PaginatedResponse<CommunityComment>>> getPostComments({
    required String postId,
    required int page,
    required int limit,
  });

  Future<Either<Failure, CommunityComment>> createComment({
    required String postId,
    required String content,
    String? parentId,
    String? replyToUserId,
  });

  Future<Either<Failure, void>> likeComment(String commentId);

  Future<Either<Failure, void>> unlikeComment(String commentId);

  Future<Either<Failure, void>> deleteComment(String commentId);
}
