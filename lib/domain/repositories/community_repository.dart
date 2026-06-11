import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/community_post.dart';
import '../entities/post_comment.dart';
import '../entities/paginated_response.dart';

abstract class CommunityRepository {
  Future<Either<Failure, PaginatedResponse<CommunityPost>>> getFarmerPosts(String farmerId, {int? limit, int? page});
  Future<Either<Failure, List<PostComment>>> getPostComments(String postId);
}
