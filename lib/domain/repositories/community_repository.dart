import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/community_post.dart';
import '../entities/post_comment.dart';

abstract class CommunityRepository {
  Future<Either<Failure, List<CommunityPost>>> getFarmerPosts(String farmerId);
  Future<Either<Failure, List<PostComment>>> getPostComments(String postId);
}
